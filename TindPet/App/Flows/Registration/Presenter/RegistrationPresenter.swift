//
//  RegistrationPresenter.swift
//  TindPet
//
//  Created by Артур Кондратьев on 06.07.2023.
//

import Foundation

protocol RegistrationViewProtocol {
}

class RegistrationPresenter {
    var view: RegistrationViewProtocol?
    var coordinator: AppCoordinatorProtocol?
}

extension RegistrationPresenter: RegistrationPresenterProtocol {
    func registrationButtonAction() {
       // coordinator?.goToMainScene()
    }
    func loginButttonAction() {
        coordinator?.goToBack()
    }
}
