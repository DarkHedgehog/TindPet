//
//  MatchService.swift
//  TindPet
//
//  Created by Asya Checkanar on 08.08.2023.
//

import Foundation
import Firebase
import FirebaseStorage

protocol MatchServiceProtocol {
    func getLikedPets(completion: @escaping (Bool, [PetInfo]?) -> Void)
    func getPetByID(petID: String, completion: @escaping (Bool, PetInfo?) -> Void)
    var delegate: MatchServiceDelegate? { get set }
}

protocol MatchServiceDelegate {
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

class MatchService: MatchServiceProtocol {
    private let auth = Auth.auth()
    private let firestore = Firestore.firestore()
    private let storage = Storage.storage().reference()
    var delegate: MatchServiceDelegate?
    let uid = Auth.auth().currentUser?.uid
    func getLikedPets(completion: @escaping (Bool, [PetInfo]?) -> Void) {
        guard let uid = uid else { return }
        var pets: [PetInfo] = []
        let ref = firestore.collection("users").document(uid).collection("petsLiked")
        ref.getDocuments { snapshot, error in
            if error == nil, let snapshot = snapshot {
                for document in snapshot.documents {
                    if let petID = document["petID"] as? String {
                        self.getPetByID(petID: petID) { didLoad, pet in
                            guard didLoad, let pet = pet else { return }
                                pets.append(pet)
                        }
                    }
                }
                completion(true, pets)
            } else {
                if let error = error as? NSError {
                    self.processError(errorID: error.code)
                    print(error)
                    completion(false, nil)
                }
            }
        }
    }
    func getOwner(ownerID: String, completion: @escaping (Bool, UserInfo?) -> Void) {
        guard let uid = uid else { return }
        firestore.collection("users").document(ownerID).getDocument { [weak self] snapshot, error in
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
            guard let dic = snapshot?.data(),
               let email = dic[Constants.email] as? String,
               let name = dic[Constants.name] as? String,
               let surname = dic[Constants.surname] as? String,
               let isOwner = dic["isOwner"] as? Bool else {
                print("guard dic failed")
                completion(false, nil)
                return
            }
            if let photo = dic["photo"] as? String {
                completion(true, UserInfo(email: email,
                                    name: name,
                                    surname: surname,
                                    isOwner: isOwner,
                                    photo: photo))
                print("\(email), \(name), \(photo)")
            } else {
                completion(true, UserInfo(email: email,
                                    name: name,
                                    surname: surname,
                                    isOwner: isOwner))
            }
        }
    }
    // MARK: - Private methods
    func getPetByID(petID: String, completion: @escaping (Bool, PetInfo?) -> Void) {
        firestore.collectionGroup("pets").whereField("petID", isEqualTo: petID).getDocuments { [weak self] querySnapshot, error in
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
            guard let docs = querySnapshot?.documents else {
                print("guard docs failed")
                strongSelf.delegate?.didNotReceiveResult()
                completion(false, nil)
                return
            }
            let doc = docs[0]
                var pet = PetInfo()
                guard let name = doc["name"] as? String,
                      let petID = doc["petID"] as? String,
                      let age = doc["age"] as? Int,
                      let species = doc["species"] as? Int,
                      let ownerID = doc["ownerID"] as? String else {
                    print("guard doc parameters failed")
                    completion(false, nil)
                    return
                }
            if let photo = doc["photo"] as? String {
                pet.photo = photo
            }
                pet.petID = petID
                pet.name = name
                pet.age = age
                pet.species = species
                pet.ownerID = ownerID
                completion(true, pet)
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
