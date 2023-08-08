//
//  PetDetailPresenter.swift
//  TindPet
//
//  Created by Aleksandr Derevenskih on 08.08.2023.
//

import Foundation

protocol PetDetailPresenterProtocol {
    func goBack()
    func getPetModel() -> PetInfoModel
}

protocol PetDetailViewProtocol {
    func setPetModel(pet: PetInfoModel)
}

final class PetDetailPresenter {
    var view: PetDetailViewProtocol?
    var coordinator: AppCoordinatorProtocol?
    let service = MatchService()

    private let petInfo: PetInfo

    init(petInfo: PetInfo) {
        self.petInfo = petInfo
    }
}

extension PetDetailPresenter: PetDetailPresenterProtocol {
    func goBack() {
        coordinator?.goToBack()
    }

    func getPetModel() -> PetInfoModel {
        return PetInfoModel(self.petInfo)
    }
}
