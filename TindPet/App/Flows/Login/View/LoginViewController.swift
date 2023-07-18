//
//  LoginViewController.swift
//  TindPet
//
//  Created by Артур Кондратьев on 06.07.2023.
//

import UIKit

protocol LoginPresenterProtocol {
    func loginAction(login: String, password: String)
    func registationButtonAction()
}

class LoginViewController: UIViewController {
    var presenter: LoginPresenterProtocol?

    private var loginView: LoginView {
        return self.view as! LoginView
    }
    let loginService: LoginServiceProtocol
    init(loginService: LoginServiceProtocol) {
        self.loginService = loginService
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private var tapGest: UITapGestureRecognizer?
    let service = FirebaseService()

    // MARK: - LifeCycle
    override func loadView() {
        super.loadView()
        self.view = LoginView()
        loginView.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addObserver()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeObserver()
        endEditing()
        loginView.endEditTextFild()
    }

    // MARK: - Functions
    private func addObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyBoardWasShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyBoardWillBeHidden),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }

    private func removeObserver() {
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }

    @objc private func keyBoardWasShow() {
        loginView.startEditTextFild()
        if tapGest == nil {
            tapGest = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        }
        guard let tapGest = tapGest else { return }
        loginView.addGestureRecognizer(tapGest)
    }

    @objc private func keyBoardWillBeHidden() {
        loginView.endEditTextFild()
    }

    @objc private func endEditing() {
        loginView.endEditing(true)
    }
}

extension LoginViewController: LoginViewDelegate {
    func loginButtonAction() {
//        presenter?.loginAction(
//            login: loginView.loginTextField.text ?? "",
//            password: loginView.passwordTextField.text ?? "")
        guard let email = loginView.loginTextField.text, !email.isEmpty,
              let password = loginView.passwordTextField.text, !password.isEmpty else {
            showAlert(title: "Ошибка", message: "Введите данные")
            return
        }
        
        loginService.signIn(email: email, password: password)
        service.signIn(email: email, password: password) { isLoggedIn in
            if isLoggedIn {
                // здесь переход на основное приложение
                UserDefaults.standard.set(true, forKey: "isLoggedIn")
                print("sign in success")
            }
        }
    }

    func registrationButtonaction() {
        navigationController?.pushViewController(RegistrationViewBuilder.build(), animated: true)
        //  presenter?.registationButtonAction()
    }
}

extension LoginViewController: LoginViewProtocol {
}
