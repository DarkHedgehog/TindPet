//
//  LoginPresenter.swift
//  TindPet
//
//  Created by Артур Кондратьев on 06.07.2023.
//

import UIKit

protocol LoginViewProtocol: UIViewController {
}

class LoginPresenter {
    var view: LoginViewProtocol?
    var coordinator: AppCoordinatorProtocol?
    var networkService: FirebaseServiceProtocol?
}

extension LoginPresenter: LoginPresenterProtocol {
    func loginAction(login: String, password: String) {
        guard login.count > 3, password.count > 3 else {
            view?.showAlert(title: "Ошибка", message: "Введите данные")
            return
        }
        networkService?.signIn(email: login, password: password) { isLoggedIn in
            if isLoggedIn {
                UserDefaults.standard.set(true, forKey: "isLogin")
                self.coordinator?.goToMainScene()
            }
        }
    }
    func registationButtonAction() {
        coordinator?.goToRegistrationVC()
    }
}
