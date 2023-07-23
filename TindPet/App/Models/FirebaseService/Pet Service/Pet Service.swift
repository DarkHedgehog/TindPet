//
//  Pet Service.swift
//  TindPet
//
//  Created by Asya Checkanar on 23.07.2023.
//

import Foundation
import Firebase

protocol PetServiceProtocol {
    func addPet(petInfo: PetInfo)
    var delegate: PetServiceDelegate? { get set }
}

protocol PetServiceDelegate {

    func didReceiveUnknownError()
    func didNotReceiveResult()
}

class PetService: PetServiceProtocol {
    private let auth = Auth.auth()
    private let firestore = Firestore.firestore()
    var delegate: PetServiceDelegate?
    
    func addPet(petInfo: PetInfo) { //add photo
        guard let uid = auth.currentUser?.uid else { return }
        let ref = firestore.collection("users").document(uid).collection("pets").document()
        let petId = ref.documentID
        let petData: [String: Any] = [
            "name": petInfo.name,
            "age": petInfo.age,
            "species": petInfo.species,
//            "photo": petInfo.photo,
            "date": Date()
        ]
        ref.setData(petData, completion: { error in
            if let err = error as? NSError {
                self.processError(errorID: err.code)
            }
        })
    }
    
    func editPet(petId: String, name: String) {
        guard let uid = auth.currentUser?.uid else {
            return
        }
        firestore.collection("users").document(uid).collection("pets").document(petId).updateData(["name": name])
    }
    func editPet(petId: String, age: Int) {
        guard let uid = auth.currentUser?.uid else {
            return
        }
        firestore.collection("users").document(uid).collection("pets").document(petId).updateData(["age": age])
    }
    func editPet(petId: String, species: Species) {
        guard let uid = auth.currentUser?.uid else {
            return
        }
        firestore.collection("users").document(uid).collection("pets").document(petId).updateData(["species": species])
    }
    private func processError(errorID: Int) {
        switch errorID {
            
        default:
            delegate?.didReceiveUnknownError()
        }
    }
}
