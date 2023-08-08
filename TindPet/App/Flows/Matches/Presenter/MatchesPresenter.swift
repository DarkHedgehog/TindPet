//
//  MatchesViewPresenter.swift
//  TindPet
//
//  Created by Aleksandr Derevenskih on 07.08.2023.
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
        description: "Безумная тварь, замурчит вас до потери сознания и перевернет все вазы в доме. Лучше кошки не бывает"
    ),
    PetInfo(petID: "3", name: "Кролик", age: 4, species: 1, ownerID: "1", photo: "", image: UIImage(named: "cat03")),
    PetInfo(petID: "4", name: "Альмир", age: 8, species: 1, ownerID: "1", photo: "", image: UIImage(named: "cat04")),
    PetInfo(petID: "1", name: "Артем", age: 123, species: 1, ownerID: "1", photo: "", image: UIImage(named: "cat01")),
    PetInfo(petID: "1", name: "Муся", age: 4, species: 0, ownerID: "1", photo: "", image: UIImage(named: "cat02"))
]

protocol MatchesViewProtocol: AnyObject {
    func setPetList(pets: [PetInfo])
}

protocol MatchesPresenterProtocol {
    func setFilter(text: String, type: FilterPetType)
    func onPetSelected(value: PetInfo)
}

final class MatchesPresenter {
    var view: MatchesViewProtocol?
    var coordinator: AppCoordinatorProtocol?
    let service = MatchService()
}

extension MatchesPresenter: MatchesPresenterProtocol {
    func onPetSelected(value: PetInfo) {
        coordinator?.goToPetDetail(value)
    }

    func setFilter(text: String, type: FilterPetType) {
        service.getLikedPets { success, list in
            let results = temporaryPetArray
            DispatchQueue.main.async {
                self.view?.setPetList(pets: results ?? [])
            }
        }
    }
}
