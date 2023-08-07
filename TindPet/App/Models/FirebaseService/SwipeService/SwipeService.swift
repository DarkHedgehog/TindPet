//
//  SwipeService.swift
//  TindPet
//
//  Created by Asya Checkanar on 01.08.2023.
//

import Foundation
import Firebase
import FirebaseStorage

protocol SwipeServiceProtocol {
    func getUserPreference(completion: @escaping (Bool, Int?) -> Void)
    func petLiked(petID: String)
    func petDisliked(petID: String)
    func getPets(preference: Int, completion: @escaping (Bool, [PetInfo]?) -> Void)
    func showNextPet(pets: [PetInfo], index: Int) -> PetInfo?
    var delegate: SwipeServiceDelegate? { get set }
}

protocol SwipeServiceDelegate {
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

class SwipeService: SwipeServiceProtocol {
    private let auth = Auth.auth()
    private let firestore = Firestore.firestore()
    private let storage = Storage.storage().reference()
    var delegate: SwipeServiceDelegate?
    let uid = Auth.auth().currentUser?.uid

    func getUserPreference(completion: @escaping (Bool, Int?) -> Void) {
        guard let uid = uid else { return }
        print(uid)
        firestore.collection("users").document(uid).getDocument { [weak self] snapshot, error in
            guard let strongSelf = self else {
                completion(false, nil)
                return
            }
            if let error = error as? NSError {
                print(error)
                strongSelf.processError(errorID: error.code)
                completion(true, 0)
                return
            }
            guard let dic = snapshot?.data() else {
                print("guard dic failed")
                strongSelf.delegate?.didNotReceiveResult()
                completion(false, nil)
                return
            }
            if let preference = dic["preference"] as? Int {
                completion(true, preference)
            } else {
                completion(true, 0)
            }
        }
    }

    func petLiked(petID: String) {
        guard let uid = uid else { return }
        let ref = firestore.collection("users").document(uid).collection("petsLiked").document()
        ref.setData(["petID": petID]) { error in
            if let error = error as? NSError {
                print(error)
                self.processError(errorID: error.code)
                return
            }
        }
    }
    func petDisliked(petID: String) {
        guard let uid = uid else { return }
        let ref = firestore.collection("users").document(uid).collection("petsDisliked").document()
        ref.setData(["petID": petID]) { error in
            if let error = error as? NSError {
                print(error)
                self.processError(errorID: error.code)
                return
            }
        }
    }
    func getPets(preference: Int, completion: @escaping (Bool, [PetInfo]?) -> Void) {
        guard let uid = uid else { return }
        var pets: [PetInfo] = [PetInfo]()
        if preference == 0 {
            firestore.collectionGroup("pets").getDocuments { [weak self] snapshot, error in
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
                guard let docs = snapshot?.documents else {
                    print("guard docs failed")
                    strongSelf.delegate?.didNotReceiveResult()
                    completion(false, nil)
                    return
                }
                for doc in docs {
                    var pet = PetInfo()
                    guard let name = doc["name"] as? String,
                        let petID = doc["petID"] as? String,
                        let age = doc["age"] as? Int,
                        let photo = doc["photo"] as? String,
                        let species = doc["species"] as? Int,
                        let ownerID = doc["ownerID"] as? String else {
                        print("guard doc parameters failed")
                        completion(false, nil)
                        return
                    }
                    pet.petID = petID
                    pet.name = name
                    pet.age = age
                    pet.photo = photo
                    pet.species = species
                    pet.ownerID = ownerID
                    pets.append(pet)
                }
                completion(true, pets)
            }
        } else {
            firestore.collectionGroup("pets").whereField("species", isEqualTo: preference).getDocuments { [weak self] snapshot, error in
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
                guard let docs = snapshot?.documents else {
                    print("guard docs failed")
                    strongSelf.delegate?.didNotReceiveResult()
                    completion(false, nil)
                    return
                }
                for doc in docs {
                    var pet = PetInfo()
                    guard let name = doc["name"] as? String,
                        let petID = doc["petID"] as? String,
                        let age = doc["age"] as? Int,
                        let photo = doc["photo"] as? String,
                        let species = doc["species"] as? Int,
                        let ownerID = doc["ownerID"] as? String else {
                        print("guard doc parameters failed")
                        completion(false, nil)
                        return
                    }
                    pet.petID = petID
                    pet.name = name
                    pet.age = age
                    pet.photo = photo
                    pet.species = species
                    pet.ownerID = ownerID
                    pets.append(pet)
                }
                completion(true, pets)
            }
        }
    }

    func showNextPet(pets: [PetInfo], index: Int) -> PetInfo? {
        guard let uid = uid else { return nil }
        var pet = PetInfo()
        if index >= pets.count {
            print("pets ran out")
        } else if index < 0 {
            print("wrong index")
        } else {
            pet = PetInfo(name: pets[index].name, age: pets[index].age, species: pets[index].species, ownerID: pets[index].ownerID, photo: pets[index].photo)
        }
        return pet
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
