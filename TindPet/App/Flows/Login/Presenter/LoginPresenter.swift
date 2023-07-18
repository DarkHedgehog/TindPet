//
//  LoginPresenter.swift
//  TindPet
//
//  Created by Артур Кондратьев on 06.07.2023.
//

import UIKit

protocol LoginViewProtocol {
    func showAlert(title: String, message: String)
}

class LoginPresenter {
    var loginService: LoginServiceProtocol
    var view: LoginViewProtocol?
    init(loginService: LoginServiceProtocol, view: LoginViewProtocol? = nil) {
        self.loginService = loginService
        self.view = view
    }
}

extension LoginPresenter: LoginPresenterProtocol {
    func loginAction(login: String, password: String) {
    }

    func registationButtonAction() {
    }
}

extension LoginPresenter: LoginServiceDelegate {
    func didSignInWith(uid: String) {
        //hide loader
    }
    func didReceiveUnverifiedEmail() {
        view?.showAlert(title: "Unverified email", message: "Unverified email")
        print("Unverified email")
    }
    func didReceiveWrongPasswordError() {
        print("Wrong password")
    }
    func didReceiveUnknownError() {
        print("Unknown error")
    }
    func didNotReceiveResult() {
        print("did not receive result")
    }
    func didSignOut() {
        print("successfully signed out")
    }
}
