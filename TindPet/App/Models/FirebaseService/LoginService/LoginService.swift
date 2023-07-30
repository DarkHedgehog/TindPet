//
//  Login Service.swift
//  TindPet
//
//  Created by Asya Checkanar on 19.07.2023.
//

import Foundation
import Firebase
import FirebaseStorage

protocol LoginServiceProtocol {
    func signIn(email: String, password: String, completion: @escaping (Bool) -> Void)
    func getCurrentUserInfo(completion: @escaping (Bool, UserInfo?) -> Void)
    func addPhoto(image: UIImage, completion: @escaping (Bool) -> Void)
    func signOut(completion: @escaping (Bool) -> Void)
    var delegate: LoginServiceDelegate? { get set }
}

protocol LoginServiceDelegate {
    func didSignInWith(uid: String)
    func didReceiveUnverifiedEmail()
    func didReceiveWrongPasswordError()
    func didReceiveInvalidEmailError()
    func didReceiveObjectNotFoundError()
    func didReceiveUnauthenticatedError()
    func didReceiveUnauthorizedError()
    func didReceiveCancelledError()
    func didReceiveRetryLimitExceededError()
    func didReceiveDocumentAlreadyExistsError()
    func didReceiveDataLossError()
    func didReceiveUnavailableError()
    func didReceiveUnknownError()
    func didNotReceiveResult()
    func didSignOut()
}

class LoginService: LoginServiceProtocol {
    private let auth = Auth.auth()
    private let firestore = Firestore.firestore()
    private let storage = Storage.storage().reference()
    var delegate: LoginServiceDelegate?
    func signIn(email: String, password: String, completion: @escaping (Bool) -> Void) {
        auth.signIn(withEmail: email, password: password) { [weak self] result, error in
            guard let strongSelf = self else {
                return
            }
            if let error = error as? NSError {
                strongSelf.processError(errorID: error.code)
                completion(false)
                return
            }
            guard let result = result else {
                strongSelf.delegate?.didNotReceiveResult()
                completion(false)
                return
            }
            guard result.user.isEmailVerified else {
                strongSelf.delegate?.didReceiveUnverifiedEmail()
                completion(false)
                return
            }
            strongSelf.didReceiveResult(result: result)
            let uid = result.user.uid
            strongSelf.firestore.collection("users").document(uid).updateData(["isVerified": true])
            completion(true)
        }
    }
    func getCurrentUserInfo(completion: @escaping (Bool, UserInfo?) -> Void) {
        guard let uid = auth.currentUser?.uid else {
            print("not logged in")
            completion(false, nil)
            return
        }
        firestore.collection("users").document(uid).getDocument { [weak self] snapshot, error in
            guard let strongSelf = self else {
                completion(false, nil)
                return
            }
            if let error = error as? NSError {
                strongSelf.processError(errorID: error.code)
                completion(false, nil)
                return
            }
            guard let dic = snapshot?.data(),
               let email = dic[Constants.email] as? String,
               let name = dic[Constants.name] as? String,
               let surname = dic[Constants.surname] as? String,
                  let photo = dic["photo"] as? String,
               let isOwner = dic["isOwner"] as? Bool else {
                completion(false, nil)
                return
            }
            completion(true, UserInfo(email: email,
                                name: name,
                                surname: surname,
                                isOwner: isOwner,
                                photo: photo))//заменить на функции в делегате
        }
    }
    func addPhoto(image: UIImage, completion: @escaping (Bool) -> Void) {
        guard let imageData = image.pngData() else {
            completion(false)
            return
        }
        guard let uid = auth.currentUser?.uid else {
            print("not logged in")
            completion(false)
            return
        }
        storage.child("images/users/\(uid).png").putData(imageData, metadata: nil) { _, error in
            guard error == nil else {
                let error = error as? NSError
                self.processError(errorID: error!.code)
                completion(false)
                return
            }
            self.storage.child("images/users/\(uid).png").downloadURL() { url, error in
                guard let url = url, error == nil else {
                    if let error = error as? NSError {
                        self.processError(errorID: error.code)
                    }
                    completion(false)
                    return
                }
                let urlString = url.absoluteString
                print("Download URL: \(urlString)")
                self.firestore.collection("users").document(uid).updateData(["photo": urlString])
                UserDefaults.standard.set(urlString, forKey: "photoUrl")
                completion(true)
            }
        }
    }
    func signOut(completion: @escaping (Bool) -> Void) {
        do {
            try auth.signOut()
        } catch {
            if let error = error as? NSError {
                processError(errorID: error.code)
                completion(false)
            }
        }
        completion(true)
    }
    // MARK: - Private methods
    private func didReceiveResult(result: AuthDataResult) {
        let uid = result.user.uid
        delegate?.didSignInWith(uid: uid)
        UserDefaults.standard.set(uid, forKey: "uid")
    }
    private func processError(errorID: Int) {
        switch errorID {
        case AuthErrorCode.unverifiedEmail.rawValue:
            delegate?.didReceiveUnverifiedEmail()
        case AuthErrorCode.wrongPassword.rawValue:
            delegate?.didReceiveWrongPasswordError()
        case AuthErrorCode.invalidEmail.rawValue:
            delegate?.didReceiveInvalidEmailError()
        case StorageErrorCode.objectNotFound.rawValue:
            delegate?.didReceiveObjectNotFoundError()
        case StorageErrorCode.unauthenticated.rawValue:
            delegate?.didReceiveUnauthenticatedError()
        case StorageErrorCode.unauthorized.rawValue:
            delegate?.didReceiveUnauthorizedError()
        case StorageErrorCode.cancelled.rawValue:
            delegate?.didReceiveCancelledError()
        case StorageErrorCode.retryLimitExceeded.rawValue:
            delegate?.didReceiveRetryLimitExceededError()
        case FirestoreErrorCode.notFound.rawValue:
            delegate?.didReceiveObjectNotFoundError()
        case FirestoreErrorCode.cancelled.rawValue:
            delegate?.didReceiveCancelledError()
        case FirestoreErrorCode.alreadyExists.rawValue:
            delegate?.didReceiveDocumentAlreadyExistsError()
        case FirestoreErrorCode.dataLoss.rawValue:
            delegate?.didReceiveDataLossError()
        case FirestoreErrorCode.unavailable.rawValue:
            delegate?.didReceiveUnavailableError()
        default:
            delegate?.didReceiveUnknownError()
        }
    }
}
