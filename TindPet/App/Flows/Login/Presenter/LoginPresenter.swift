//
//  LoginPresenter.swift
//  TindPet
//
//  Created by Артур Кондратьев on 06.07.2023.
//

import UIKit

protocol LoginViewProtocol {
    func showAlerts(title: String, message: String)
}

class LoginPresenter {
    var loginService: LoginServiceProtocol
    var view: LoginViewProtocol?
    init(loginService: LoginServiceProtocol, view: LoginViewProtocol? = nil) {
        self.loginService = loginService
        self.loginService.delegate = self
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
        view?.showAlerts(title: "Unverified email", message: "Please verify your email")
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
