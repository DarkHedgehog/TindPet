//
//  MatchesViewPresenter.swift
//  TindPet
//
//  Created by Aleksandr Derevenskih on 07.08.2023.
//

import Foundation
import UIKit

let temporaryPetArray: [PetInfo] = [
    PetInfo(petID: "1", name: "Вася", age: 3, species: 0, ownerID: "1", photo: "", image: UIImage(named: "person")),
    PetInfo(petID: "1", name: "Муся", age: 4, species: 1, ownerID: "1", photo: "", image: UIImage(named: "person")),
    PetInfo(petID: "1", name: "Ася", age: 23, species: 0, ownerID: "1", photo: "", image: UIImage(named: "person")),
    PetInfo(petID: "1", name: "Леха", age: 44, species: 1, ownerID: "1", photo: "", image: UIImage(named: "person")),
    PetInfo(petID: "1", name: "Артем", age: 123, species: 1, ownerID: "1", photo: "", image: UIImage(named: "person")),
    PetInfo(petID: "1", name: "Муся", age: 4, species: 1, ownerID: "1", photo: "", image: UIImage(named: "person")),
]

protocol MatchesViewProtocol: AnyObject {
    func setPetList(pets: [PetInfo])
}

protocol MatchesPresenterProtocol {
    func setFilter(text: String, type: FilterPetType)
}

final class MatchesPresenter {
    var view: MatchesViewProtocol?
    var coordinator: AppCoordinatorProtocol?
    let service = MatchService()
}

extension MatchesPresenter: MatchesPresenterProtocol {
    func setFilter(text: String, type: FilterPetType) {
        service.getLikedPets { success, list in
            let results = temporaryPetArray
            DispatchQueue.main.async {
                self.view?.setPetList(pets: results ?? [])
            }
        }
    }
}
