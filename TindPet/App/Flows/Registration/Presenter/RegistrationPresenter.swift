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
    init(registrationService: RegistrationServiceProtocol) {
        self.registrationService = registrationService
        self.registrationService.delegate = self
    }
}

extension RegistrationPresenter: RegistrationPresenterProtocol {
    func didTapRegister(name: String, surname: String, email: String, password: String) {
        let credentials = Credentials(name: name, surname: surname, email: email, password: password)
        registrationService.registerNewUser(credentials: credentials)
        //loader
    }
}

extension RegistrationPresenter: RegistrationServiceDelegate {
    func didRegisterWith(uid: String) {
        //hide loader
    }
    func didReceiveEmailAlreadyInUseError() {
        print("Email already in use")
    }
    func didReceiveUnknownError() {
        print("Uknown error")
    }
    func didNotReceiveResult() {
        print("did not receive result")
    }

}
