//
//  Edit Profile Service.swift
//  TindPet
//
//  Created by Asya Checkanar on 23.07.2023.
//

import Foundation
import Firebase

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
    //add avatar
    private func processError(errorID: Int) {
        switch errorID {
        default:
            delegate?.didReceiveUnknownError()
        }
    }
}
