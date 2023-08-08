//
//  PetDetailPresenter.swift
//  TindPet
//
//  Created by Aleksandr Derevenskih on 08.08.2023.
//

import Foundation

protocol PetDetailPresenterProtocol {
    func goBack()
}

protocol PetDetailViewProtocol {
    
}

final class PetDetailPresenter {
    var view: PetDetailViewProtocol?
    var coordinator: AppCoordinatorProtocol?
    let service = MatchService()

    private let petId: String

    init(petId: String) {
        self.petId = petId
    }
}

extension PetDetailPresenter: PetDetailPresenterProtocol {
    func goBack() {
        coordinator?.goToBack()
    }
}
