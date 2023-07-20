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
    var registrationService: RegistrationServiceProtocol
    var view: RegistrationViewProtocol?
    init(registrationService: RegistrationServiceProtocol, view: RegistrationViewProtocol? = nil) {
        self.registrationService = registrationService
        self.registrationService.delegate = self
        self.view = view
    }
}

extension RegistrationPresenter: RegistrationPresenterProtocol {
}

extension RegistrationPresenter: RegistrationServiceDelegate {
    func didRegisterWith(uid: String) {
        //hide loader
    }
    func didReceiveEmailAlreadyInUseError() {
        print("Email already in use")
    }
    func didReceiveUnknownError() {
        print("Unknown error")
    }
    func didNotReceiveResult() {
        print("did not receive result")
    }
}
