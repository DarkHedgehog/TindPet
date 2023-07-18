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
    var view: RegistrationViewProtocol?
    var coordinator: AppCoordinatorProtocol?
    var networkService: FirebaseServiceProtocol?
}

extension RegistrationPresenter: RegistrationPresenterProtocol {
    func registrationButtonAction(name: String?, surname: String?, email: String?, password: String?, state: Int) {
        guard let name = name, !name.isEmpty,
              let surname = surname, !surname.isEmpty,
              let email = email, !email.isEmpty,
              let password = password, !password.isEmpty else {
            view?.showInfo(title: "Ошибка", message: "Введите данные")
            return
        }
        networkService?.registerNewUser(
            name: name,
            surname: surname,
            email: email,
            password: password) { isRegistered in
                if isRegistered {
                    self.view?.showInfo(title: "Подтвердите регистрацию",
                                         message: "На Вашу почту было выслано сообщение с подтверждением регистрации")
                    self.coordinator?.goToMainScene()
                } else {
                    self.view?.showInfo(title: "Ошибка регистарции",
                                         message: "Возможно пользователь с таким логином уже существует")
                }
            }
    }
    func loginButttonAction() {
        coordinator?.goToBack()
    }
}
