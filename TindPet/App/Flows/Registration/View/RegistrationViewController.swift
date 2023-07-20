//
//  RegistrationViewController.swift
//  TindPet
//
//  Created by Aleksandr Derevenskih on 21.06.2023.
//

import UIKit

protocol RegistrationPresenterProtocol {
}

final class RegistrationViewController: UIViewController {
    var presenter: RegistrationPresenterProtocol?
    private var tapGest: UITapGestureRecognizer?
    private var regView: RegistrationView {
        return self.view as! RegistrationView
    }
//    let service = FirebaseService()
    let registrationService: RegistrationServiceProtocol
    init(registrationService: RegistrationServiceProtocol) {
        self.registrationService = registrationService
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - LifeCycle
    override func loadView() {
        super.loadView()
        self.view = RegistrationView()
        regView.delegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addObserver()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeObserver()
        endEditing()
    }

    // MARK: - Functions
    private func configureNavBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem()
    }

    private func addObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyBoardWasShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyBoardWillBeHidden(notification:)),
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

    @objc private func keyBoardWasShow(notification: Notification) {
        if tapGest == nil {
            tapGest = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        }
        guard let tapGest = tapGest,
            let info = notification.userInfo as? NSDictionary,
            let value = info.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as? NSValue
            else { return }
        regView.addGestureRecognizer(tapGest)

        let kbSize = value.cgRectValue.size
        let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: kbSize.height, right: 0)

        regView.scrollView.contentInset = contentInset
        regView.scrollView.scrollIndicatorInsets = contentInset
    }

    @objc private func keyBoardWillBeHidden(notification: Notification) {
        let contentInset = UIEdgeInsets.zero
        regView.scrollView.contentInset = contentInset
    }

    @objc private func endEditing() {
        regView.endEditing(true)
    }
}

extension RegistrationViewController: RegistrationViewDelegate {
    func regButtonAction() {
        //проверить, что данные есть
        guard let name = regView.nameTextField.text, !name.isEmpty,
            let surname = regView.surnameTextField.text, !surname.isEmpty,
            let email = regView.emailTextField.text, !email.isEmpty,
            let password = regView.passwordTextField.text, !password.isEmpty else {
            showAlert(title: "Ошибка", message: "Введите данные")
            return
        }
        let credentials = Credentials(name: name, surname: surname, email: email, password: password)
//        регистрация -> alert  что человеку нужно подтвердить регистрацию по почте и перезапустить приложение
        registrationService.registerNewUser(credentials: credentials)
//         { isRegistered in
//            if isRegistered {
//                self.showAlert(
//                    title: "Подтвердите регистрацию",
//                    message: "На Вашу почту было выслано сообщение с подтверждением регистрации"
//                )
//                self.navigationController?.popViewController(animated: true)
//            }
//        }
    }

    func loginButtonAction() {
        navigationController?.popViewController(animated: true)
    }
}

extension RegistrationViewController: RegistrationViewProtocol {
}
