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
    init(loginService: LoginServiceProtocol) {
        self.loginService = loginService
        self.loginService.delegate = self
    }
}

extension LoginPresenter: LoginPresenterProtocol {
    func loginAction(login: String?, password: String?) {
        guard let login = login, !login.isEmpty, let password = password, !password.isEmpty else {
            view?.showInfo(title: "Ошибка", message: "Введите данные")
            return
        }
        loginService.signIn(email: login, password: password)
    }
    func registationButtonAction() {
        coordinator?.goToRegistrationVC()
    }
}

extension LoginPresenter: LoginServiceDelegate {
    func didSignInWith(uid: String) {
        UserDefaults.standard.set(uid, forKey: Key.uid)
        UserDefaults.standard.set(true, forKey: Key.isLogin)
        self.coordinator?.goToMainScene()
    }
    func didReceiveUnverifiedEmail() {
        view?.showInfo(title: "Unverified email", message: "Please verify your email")
    }
    func didReceiveWrongPasswordError() {
        print("Wrong password")
    }
    func didReceiveUnknownError() {
        view?.showInfo(title: "Ошибка", message: "Неверный логин или пароль")
    }
    func didNotReceiveResult() {
        print("Did not receive result")
    }
    func didSignOut() {
        print("successfully signed out")
    }
}
