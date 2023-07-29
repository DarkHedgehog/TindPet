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
    func updateCurrentUserData(name: String)
    func updateCurrentUserData(surname: String)
    func updateCurrentUserData(email: String)
    func updateCurrentUserData(password: String)
    var delegate: EditServiceDelegate? { get set }
}

protocol EditServiceDelegate {
    func didNotReceiveResult()
    func didReceiveUnknownError()
}

class EditService: EditServiceProtocol {
    private let auth = Auth.auth()
    private let firestore = Firestore.firestore()
    private let storage = Storage.storage().reference()
    var delegate: EditServiceDelegate?
    let uid = Auth.auth().currentUser?.uid

    func updateCurrentUserData(name: String) {
        guard let uid = uid else { return }
        firestore.collection("users").document(uid).updateData(["name": name])
    }
    func updateCurrentUserData(surname: String) {
        guard let uid = uid else { return }
        firestore.collection("users").document(uid).updateData(["surname": surname])
    }
    func updateCurrentUserData(email: String) {
        guard let uid = uid else { return }
        firestore.collection("users").document(uid).updateData(["email": email])
    }
    func updateCurrentUserData(password: String) {
        guard let uid = uid else { return }
        firestore.collection("users").document(uid).updateData(["password": password])
    }
    func updateCurrentUserData(isOwner: Bool) {
        guard let uid = uid else { return }
        firestore.collection("users").document(uid).updateData(["isOwner": isOwner])
    }
    func updateCurrentUserData(photo: String) {
        guard let uid = uid else { return }
        firestore.collection("users").document(uid).updateData(["photo": photo])
    }
    func updateCurrentUserData(image: UIImage) {
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
    private func processError(errorID: Int) {
        switch errorID {
        default:
            delegate?.didReceiveUnknownError()
        }
    }
}
