//
//  MatchesStaticService.swift
//  TindPet
//
//  Created by Aleksandr Derevenskih on 09.08.2023.
//

import Foundation
import UIKit


let temporaryPetArray: [PetInfo] = [
    PetInfo(
        petID: "1",
        name: "Мурзик",
        age: 3,
        species: 1,
        ownerID: "1",
        photo: "",
        image: UIImage(named: "cat01"),
        description: "Милый хороший котик"
    ),
    PetInfo(
        petID: "2",
        name: "Муха",
        age: 4,
        species: 0,
        ownerID: "1",
        photo: "",
        image: UIImage(named: "cat02"),
        description: "Безумно дружелюбное создание, замурчит вас до потери пульса и перевернет все вазы в доме. Лучше кошки не бывает"
    ),
    PetInfo(petID: "3", name: "Кролик", age: 4, species: 1, ownerID: "1", photo: "", image: UIImage(named: "cat03")),
    PetInfo(petID: "4", name: "Альмир", age: 8, species: 1, ownerID: "1", photo: "", image: UIImage(named: "cat04")),
    PetInfo(petID: "5", name: "Артем", age: 123, species: 1, ownerID: "1", photo: "", image: UIImage(named: "cat01")),
    PetInfo(petID: "6", name: "Муся", age: 4, species: 0, ownerID: "1", photo: "", image: UIImage(named: "cat02"))
]

final class MatchesStaticService: MatchServiceProtocol {
    var delegate: MatchServiceDelegate?

    func getLikedPets(completion: @escaping (Bool, [PetInfo]?) -> Void) {
        completion(true, temporaryPetArray)
    }

    func getPetByID(petID: String, completion: @escaping (Bool, PetInfo?) -> Void) {
        let result = temporaryPetArray.first { $0.petID == petID }
        completion(true, result)
    }
}

final class  SwipeStaticService: SwipeServiceProtocol {
    var delegate: SwipeServiceDelegate?
    func getUserPreference(completion: @escaping (Bool, Int?) -> Void) {
        completion(true, 0)
    }

    func petLiked(petID: String) {
    }

    func petDisliked(petID: String) {
    }

    func getPets(preference: Int, completion: @escaping (Bool, [PetInfo]?) -> Void) {
        completion(true, temporaryPetArray)
    }

    func showNextPet(pets: [PetInfo], index: Int) -> PetInfo? {
        let existsIndex = index % temporaryPetArray.count
        return temporaryPetArray[existsIndex]
    }
}
