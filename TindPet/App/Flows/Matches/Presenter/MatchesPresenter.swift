//
//  MatchesViewPresenter.swift
//  TindPet
//
//  Created by Aleksandr Derevenskih on 07.08.2023.
//

import Foundation

protocol MatchesViewProtocol: AnyObject {
    func setPetList(pets: [PetInfoModel])
}

protocol MatchesPresenterProtocol {
    func setFilter(text: String, type: FilterPetType)
    func onPetSelected(value: PetInfoModel)
}

final class MatchesPresenter {
    var view: MatchesViewProtocol?
    var coordinator: AppCoordinatorProtocol?
    let service = MatchesStaticService()

    func petInfoToModels(_ list: [PetInfo]) -> [PetInfoModel] {
        return list.map { PetInfoModel($0) }
    }
}

extension MatchesPresenter: MatchesPresenterProtocol {
    func onPetSelected(value: PetInfoModel) {
        service.getPetByID(petID: value.petID) { success, petInfo in
            if let petInfo = petInfo {
                self.coordinator?.goToPetDetail(petInfo)
            }
        }
    }

    func setFilter(text: String, type: FilterPetType) {
        service.getLikedPets { _, list in
            DispatchQueue.main.async {
                let petModels = self.petInfoToModels(list ?? [])
                self.view?.setPetList(pets: petModels)
            }
        }
    }
}
