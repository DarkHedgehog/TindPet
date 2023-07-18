//
//  LoginPresenter.swift
//  TindPet
//
//  Created by Артур Кондратьев on 06.07.2023.
//

import Foundation

protocol LoginViewProtocol {
    func showInfo(title: String, message: String)
}

class LoginPresenter {
    var view: LoginViewProtocol?
    var coordinator: AppCoordinatorProtocol?
    var networkService: FirebaseServiceProtocol?
}

extension LoginPresenter: LoginPresenterProtocol {
    func loginAction(login: String?, password: String?) {
        guard let login = login, !login.isEmpty, let password = password, !password.isEmpty else {
            view?.showInfo(title: "Ошибка", message: "Введите данные")
            return
        }
        networkService?.signIn(email: login, password: password) { isLoggedIn in
            if isLoggedIn {
                UserDefaults.standard.set(true, forKey: KeyConstants.isLogin)
                self.coordinator?.goToMainScene()
            }
        }
    }
    func registationButtonAction() {
        coordinator?.goToRegistrationVC()
    }
}
