//
//  Pet Service.swift
//  TindPet
//
//  Created by Asya Checkanar on 23.07.2023.
//

import Foundation
import Firebase
import FirebaseStorage

protocol PetServiceProtocol {
    func addPet(petInfo: PetInfo, photo: UIImage, completion: @escaping (Bool) -> Void)
    func editPet(petId: String, name: String)
    func editPet(petId: String, age: Int)
    func editPet(petId: String, species: Species)
    func getPets(completion: @escaping ([PetInfo]) -> Void)
    var delegate: PetServiceDelegate? { get set }
}

protocol PetServiceDelegate {
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
}

class PetService: PetServiceProtocol {
    private let auth = Auth.auth()
    private let firestore = Firestore.firestore()
    private let storage = Storage.storage().reference()
    var delegate: PetServiceDelegate?
    let uid = Auth.auth().currentUser?.uid
    func addPet(petInfo: PetInfo, photo: UIImage, completion: @escaping (Bool) -> Void) {
        guard let uid = uid else { return }
        let ref = firestore.collection("users").document(uid).collection("pets").document()
        let petId = ref.documentID
        addPetPhoto(petID: petId, image: photo, completion: { url in
            let photoUrl = url
            let petData: [String: Any] = [
                "name": petInfo.name,
                "age": petInfo.age,
                "species": petInfo.species,
                "photo": photoUrl,
                "date": Date(),
                "ownerID": uid
            ]
            ref.setData(petData, completion: { error in
                if let err = error as? NSError {
                    self.processError(errorID: err.code)
                    completion(false)
                }
            })
            completion(true)
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
                   let photo = document["photo"] as? String,
                   let species = document["species"] as? Species,
                   let age = document["age"] as? Int {
                    let petInfo = PetInfo(name: name, age: age, species: species, ownerID: ownerID, photo: photo)
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
    func addPetPhoto(petID: String, image: UIImage, completion: @escaping (String) -> Void) {
        guard let imageData = image.pngData() else {
            return
        }
        //replace with userid
        storage.child("images/users/\(petID).png").putData(imageData, metadata: nil) { _, error in
            guard error == nil else {
                let error = error as? NSError
                self.processError(errorID: error!.code)
                return
            }
            self.storage.child("images/users/\(petID).png").downloadURL() { url, error in
                guard let url = url, error == nil else {
                    return
                }
                let urlString = url.absoluteString
                //replace with saving url
                print("Download URL: \(urlString)")
                completion(urlString)
            }
        }
    }
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
