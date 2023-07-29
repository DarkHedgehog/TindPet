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
    func signIn(email: String, password: String)
    func addPhoto(image: UIImage)
    var delegate: LoginServiceDelegate? { get set }
}

protocol LoginServiceDelegate {
    func didSignInWith(uid: String)
    func didReceiveUnverifiedEmail()
    func didReceiveWrongPasswordError()
    func didReceiveUnknownError()
    func didNotReceiveResult()
    func didSignOut()
}

class LoginService: LoginServiceProtocol {
    private let auth = Auth.auth()
    private let firestore = Firestore.firestore()
    private let storage = Storage.storage().reference()
    var delegate: LoginServiceDelegate?
    func signIn(email: String, password: String) {
        auth.signIn(withEmail: email, password: password) { [weak self] result, error in
            guard let strongSelf = self else {
                return
            }
            if let error = error as? NSError {
                strongSelf.processError(errorID: error.code)
                return
            }
            guard let result = result else {
                strongSelf.delegate?.didNotReceiveResult()
                return
            }
            guard result.user.isEmailVerified else {
                strongSelf.delegate?.didReceiveUnverifiedEmail()
                return
            }
            strongSelf.didReceiveResult(result: result)
        }
    }
    private func didReceiveResult(result: AuthDataResult) {
        let uid = result.user.uid
        delegate?.didSignInWith(uid: uid)
        UserDefaults.standard.set(true, forKey: "isLoggedIn")
        UserDefaults.standard.set(uid, forKey: "uid")
    }
    private func processError(errorID: Int) {
        switch errorID {
        case AuthErrorCode.emailAlreadyInUse.rawValue:
            delegate?.didReceiveWrongPasswordError()
        default:
            delegate?.didReceiveUnknownError()
        }
    }
    func getCurrentUserInfo(completion: @escaping (UserInfo) -> Void) {
        guard let uid = auth.currentUser?.uid else {
            print("not logged in")
            return
        }
        firestore.collection("users").document(uid).getDocument { [weak self] snapshot, error in
            guard let strongSelf = self else {
                return
            }
            if let error = error as? NSError {
                strongSelf.processError(errorID: error.code)
                return
            }
            guard let dic = snapshot?.data(),
               let email = dic[Constants.email] as? String,
               let name = dic[Constants.name] as? String,
               let surname = dic[Constants.surname] as? String,
                  let photo = dic["photo"] as? String,
               let isOwner = dic["isOwner"] as? Bool else {
                return
            }
            completion(UserInfo(email: email,
                                name: name,
                                surname: surname,
                                isOwner: isOwner,
                                photo: photo))//заменить на функции в делегате
        }
    }
    func addPhoto(image: UIImage) {
        guard let imageData = image.pngData() else {
            return
        }
        guard let uid = auth.currentUser?.uid else {
            print("not logged in")
            return
        }
        storage.child("images/users/\(uid).png").putData(imageData, metadata: nil) { _, error in
            guard error == nil else {
                let error = error as? NSError
                self.processError(errorID: error!.code)
                return
            }
            self.storage.child("images/users/\(uid).png").downloadURL() { url, error in
                guard let url = url, error == nil else {
                    return
                }
                let urlString = url.absoluteString
                print("Download URL: \(urlString)")
                self.firestore.collection("users").document(uid).updateData(["photo": urlString])
                UserDefaults.standard.set(urlString, forKey: "photoUrl")
            }
        }
    }
    func signOut() {
        do {
            try auth.signOut()
        } catch {
            if let error = error as? NSError {
                processError(errorID: error.code)
            }
        }
    }
}
