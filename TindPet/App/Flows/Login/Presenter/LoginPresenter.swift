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
    var loginService: LoginServiceProtocol
    var view: LoginViewProtocol?
    var coordinator: AppCoordinatorProtocol?
    var networkService: FirebaseServiceProtocol?

    init(loginService: LoginServiceProtocol, view: LoginViewProtocol? = nil) {
        self.loginService = loginService
        self.loginService.delegate = self
        self.view = view
    }
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

extension LoginPresenter: LoginServiceDelegate {
    func didSignInWith(uid: String) {
        //hide loader
    }
    func didReceiveUnverifiedEmail() {
        view?.showInfo(title: "Unverified email", message: "Please verify your email")
        print("Unverified email")
    }
    func didReceiveWrongPasswordError() {
        print("Wrong password")
    }
    func didReceiveUnknownError() {
        print("Unknown error")
    }
    func didNotReceiveResult() {
        print("Did not receive result")
    }
    func didSignOut() {
        print("successfully signed out")
    }
    
    
    
}
