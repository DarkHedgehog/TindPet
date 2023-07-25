//
//  Pet Service.swift
//  TindPet
//
//  Created by Asya Checkanar on 23.07.2023.
//

import Foundation
import Firebase

protocol PetServiceProtocol {
    func addPet(petInfo: PetInfo, completion: @escaping (Bool) -> Void)
    func editPet(petId: String, name: String)
    func editPet(petId: String, age: Int)
    func editPet(petId: String, species: Species)
    func getPets(completion: @escaping ([PetInfo]) -> Void)
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
    let uid = Auth.auth().currentUser?.uid
    func addPet(petInfo: PetInfo, completion: @escaping (Bool) -> Void) { //add photo
        guard let uid = uid else { return }
        let ref = firestore.collection("users").document(uid).collection("pets").document()
        let petId = ref.documentID
        let petData: [String: Any] = [
            "name": petInfo.name,
            "age": petInfo.age,
            "species": petInfo.species,
//            "photo": petInfo.photo,
            "date": Date(),
            "ownerID": uid
        ]
        ref.setData(petData, completion: { error in
            if let err = error as? NSError {
                self.processError(errorID: err.code)
            }
        })
    }
    func editPet(petId: String, name: String) {
        guard let uid = uid else { return }
        firestore.collection("users").document(uid).collection("pets").document(petId).updateData(["name": name])
    }
    func editPet(petId: String, age: Int) {
        guard let uid = uid else { return }
        firestore.collection("users").document(uid).collection("pets").document(petId).updateData(["age": age])
    }
    func editPet(petId: String, species: Species) {
        guard let uid = uid else { return }
        firestore.collection("users").document(uid).collection("pets").document(petId).updateData(["species": species])
    }
    func getPets(completion: @escaping ([PetInfo]) -> Void) {
        guard let uid = uid else { return }
        var pets: [PetInfo] = []
        let ref = firestore.collection("users").document(uid).collection("pets")
        ref.getDocuments(completion: { snapshot, error in
            if error == nil {
                for document in snapshot!.documents {
                if let ownerID = document["ownerID"] as? String,
                   let name = document["name"] as? String,
//                   let photo = document["photo"] as? String,
                   let species = document["species"] as? Species,
                   let age = document["age"] as? Int {
                    let petInfo = PetInfo(name: name, age: age, species: species, ownerID: ownerID)
//                    petInfo.photo = photo
                    pets.append(petInfo)
                    }
                }
                completion(pets)
            } else {
                if let error = error as? NSError {
                    // TODO: прописать работу с ошибками
                    print(error)
                }
            }
        })
    }
    private func processError(errorID: Int) {
        switch errorID {
        default:
            delegate?.didReceiveUnknownError()
        }
    }
}
