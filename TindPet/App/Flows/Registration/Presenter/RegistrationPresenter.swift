//
//  RegistrationPresenter.swift
//  TindPet
//
//  Created by Артур Кондратьев on 06.07.2023.
//

import Foundation

protocol RegistrationViewProtocol: AnyObject {
    func showInfo(title: String, message: String)
}

class RegistrationPresenter {
    var registrationService: RegistrationServiceProtocol
    var view: RegistrationViewProtocol?
    var coordinator: AppCoordinatorProtocol?
    var networkService: FirebaseServiceProtocol?
    init(registrationService: RegistrationServiceProtocol) {
        self.registrationService = registrationService
        self.registrationService.delegate = self
    }
}

extension RegistrationPresenter: RegistrationPresenterProtocol {
    func registrationButtonAction(name: String?, surname: String?, email: String?, password: String?, state: Int) {
        guard let name = name, !name.isEmpty,
              let surname = surname, !surname.isEmpty,
              let email = email, !email.isEmpty,
              let password = password, !password.isEmpty,
              let state = state == 0 ? false : true
        else {
            view?.showInfo(title: "Ошибка", message: "Введите данные")
            return
        }
        let credentials = Credentials(
            name: name,
            surname: surname,
            email: email,
            password: password,
            isOwner: state)
        registrationService.registerNewUser(credentials: credentials)
    }
    func loginButttonAction() {
        coordinator?.goToBack()
    }
}

extension RegistrationPresenter: RegistrationServiceDelegate {
    func didReceiveUserNotFoundError() {
        self.view?.showInfo(
            title: "Ошибка верификации",
            message: "Пользователь не найден, письмо верификации не отправлено"
        )
    }
    
    func didReceiveInvalidEmailError() {
        self.view?.showInfo(
            title: "Ошибка регистрации",
            message: "Указанный адрес почты не существует"
        )
    }
    
    func didRegisterWith(uid: String) {
    }
    func didReceiveEmailAlreadyInUseError() {
        self.view?.showInfo(
            title: "Ошибка регистрации",
            message: "Этот электронный адрес уже занят"
        )
    }
    func didReceiveUnknownError() {
        print("Unknown error")
    }
    func didNotReceiveResult() {
        self.view?.showInfo(
            title: "Ошибка",
            message: "Данные не были получены"
        )
    }
}
