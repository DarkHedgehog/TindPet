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
    var delegate: EditServiceDelegate? { get set }
}

protocol EditServiceDelegate {
    func didReceiveResult()
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
        firestore.collection("users").document(uid).updateData(["photoUrl": photoUrl]) { error in
            guard error == nil else {
                let error = error as? NSError
                self.processError(errorID: error!.code)
                completion(false)
                return
            }
            completion(true)
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
    //MARK: - Private methods
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
