//
//  LoginPresenter.swift
//  TindPet
//
//  Created by Артур Кондратьев on 06.07.2023.
//

import UIKit

protocol LoginViewProtocol {
    
}

class LoginPresenter {
    
    var view: LoginViewProtocol?
    
}

extension LoginPresenter: LoginPresenterProtocol {
    func loginAction(login: String, password: String) {
        
    }
    
    func registationButtonAction() {
        
    }
}
