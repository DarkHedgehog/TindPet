//
//  Edit Profile Service.swift
//  TindPet
//
//  Created by Asya Checkanar on 23.07.2023.
//

import Foundation
import Firebase
import FirebaseStorage

protocol EditServiceProtocol {
    func updateCurrentUserData(name: String, completion: @escaping (Bool) -> Void)
    func updateCurrentUserData(surname: String, completion: @escaping (Bool) -> Void)
    func updateCurrentUserData(email: String, completion: @escaping (Bool) -> Void)
    func updateCurrentUserData(password: String, completion: @escaping (Bool) -> Void)
    func updateCurrentUserData(isOwner: Bool, completion: @escaping (Bool) -> Void)
    func updateCurrentUserData(photoUrl: String, completion: @escaping (Bool) -> Void)
    func updateCurrentUserData(image: UIImage, completion: @escaping (Bool) -> Void)
    func updateCurrentUserData(preference: Int, completion: @escaping (Bool) -> Void)
    func getCurrentUserInfo(completion: @escaping (Bool, UserInfo?) -> Void)
    func loadPetPhotoToPetID(petID: String)
    func signOut(completion: @escaping (Bool) -> Void)
    var delegate: EditServiceDelegate? { get set }
}

protocol EditServiceDelegate {
    func didReceiveObjectNotFoundError()
    func didReceiveUnauthenticatedError()
    func didReceiveUnauthorizedError()
    func didReceiveCancelledError()
    func didReceiveRetryLimitExceededError()
    func didReceiveDocumentAlreadyExistsError()
    func didReceiveDataLossError()
    func didReceiveUnavailableError()
    func didNotReceiveResult()
    func didReceiveUnknownError()
}

class EditService: EditServiceProtocol {
    private let auth = Auth.auth()
    private let firestore = Firestore.firestore()
    private let storage = Storage.storage().reference()
    var delegate: EditServiceDelegate?
    let uid = Auth.auth().currentUser?.uid

    func updateCurrentUserData(name: String, completion: @escaping (Bool) -> Void) {
        guard let uid = uid else { return }
        firestore.collection("users").document(uid).updateData(["name": name]) { error in
            guard error == nil else {
                let error = error as? NSError
                self.processError(errorID: error!.code)
                completion(false)
                return
            }
            completion(true)
        }
    }
    func updateCurrentUserData(surname: String, completion: @escaping (Bool) -> Void) {
        guard let uid = uid else { return }
        firestore.collection("users").document(uid).updateData(["surname": surname]) { error in
            guard error == nil else {
                let error = error as? NSError
                self.processError(errorID: error!.code)
                completion(false)
                return
            }
            completion(true)
        }
    }
    func updateCurrentUserData(email: String, completion: @escaping (Bool) -> Void) {
        guard let uid = uid else { return }
        firestore.collection("users").document(uid).updateData(["email": email]) { error in
            guard error == nil else {
                let error = error as? NSError
                self.processError(errorID: error!.code)
                completion(false)
                return
            }
            completion(true)
        }
    }
    func updateCurrentUserData(password: String, completion: @escaping (Bool) -> Void) {
        guard let uid = uid else { return }
        firestore.collection("users").document(uid).updateData(["password": password]) { error in
            guard error == nil else {
                let error = error as? NSError
                self.processError(errorID: error!.code)
                completion(false)
                return
            }
            completion(true)
        }
    }
    func updateCurrentUserData(isOwner: Bool, completion: @escaping (Bool) -> Void) {
        guard let uid = uid else { return }
        firestore.collection("users").document(uid).updateData(["isOwner": isOwner]) { error in
            guard error == nil else {
                let error = error as? NSError
                self.processError(errorID: error!.code)
                completion(false)
                return
            }
            completion(true)
        }
    }
    func updateCurrentUserData(photoUrl: String, completion: @escaping (Bool) -> Void) {
        guard let uid = uid else { return }
        firestore.collection("users").document(uid).updateData(["photo": photoUrl]) { error in
            guard error == nil else {
                let error = error as? NSError
                self.processError(errorID: error!.code)
                completion(false)
                return
            }
            completion(true)
        }
    }
    func updateCurrentUserData(preference: Int, completion: @escaping (Bool) -> Void) {
        guard let uid = uid else { return }
        //        if firestore.collection("users").document(uid).upda
        firestore.collection("users").document(uid).updateData(["preference": preference]) { error in
            if error == nil {
                completion(true)
            } else {
                let error = error as? NSError
                switch error!.code {
                case FirestoreErrorCode.notFound.rawValue:
                    self.firestore.collection("users").document(uid).setData(["preference": preference])
                default:
                    self.processError(errorID: error!.code)
                    completion(false)
                    return
                }
            }
        }
    }
    func updateCurrentUserData(image: UIImage, completion: @escaping (Bool) -> Void) {
        guard let imageData = image.pngData() else {
            return
        }
        guard let uid = uid else { return }
        storage.child("images/users/\(uid).png").putData(imageData, metadata: nil) { _, error in
            guard error == nil else {
                let error = error as? NSError
                self.processError(errorID: error!.code)
                return
            }
            self.storage.child("images/users/\(uid).png").downloadURL { url, error in
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
                print(error)
                strongSelf.processError(errorID: error.code)
                completion(false, nil)
                return
            }
            var preference = 0
            guard let dic = snapshot?.data(),
               let email = dic[Constants.email] as? String,
               let name = dic[Constants.name] as? String,
               let surname = dic[Constants.surname] as? String,
               let isOwner = dic["isOwner"] as? Bool else {
                print("guard dic failed")
                completion(false, nil)
                return
            }
            if let pref = dic["preference"] as? Int {
                preference = pref
            } else {
                strongSelf.updateCurrentUserData(preference: preference) { didLoad in
                    if didLoad {
                        print("did load preference")
                    } else {
                        print("did not load preference")
                    }
                }
            }
            if let photo = dic["photo"] as? String {
                completion(true, UserInfo(email: email,
                                    name: name,
                                    surname: surname,
                                    isOwner: isOwner,
                                    photo: photo,
                                    preference: preference))
                print("\(email), \(name), \(photo)")
            } else {
                completion(true, UserInfo(email: email,
                                    name: name,
                                    surname: surname,
                                    isOwner: isOwner,
                                    preference: preference))
            }
            print("\(email), \(name)")
        }
    }
    func loadPetPhotoToPetID(petID: String) {
        guard let uid = uid else { return }
        let petRef = storage.child("images/pets/\(petID)")
        petRef.downloadURL { [weak self] url, error in
            guard let strongSelf = self else {
                //completion(false, nil)
                return
            }
            if let error = error as? NSError {
                print(error)
                strongSelf.processError(errorID: error.code)
                //completion(false, nil)
                return
            }
            print("petID: \(petID), url: \(url)")
        }
    }
    // MARK: - Private methods
    private func processError(errorID: Int) {
        switch errorID {
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
