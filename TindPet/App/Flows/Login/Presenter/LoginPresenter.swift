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
    func didReceiveUnavailableError() {
        view?.showInfo(title: "Ошибка соединения", message: "Сервис временно недоступен")
    }
    func didReceiveDocumentAlreadyExistsError() {
        view?.showInfo(title: "Ошибка", message: "Объект уже существует")
    }
    func didReceiveDataLossError() {
        view?.showInfo(title: "Ошибка", message: "Данные утеряны")
    }
    func didReceiveObjectNotFoundError() {
        view?.showInfo(title: "Ошибка", message: "Объект не найден в базе данных")
    }
    func didReceiveUnauthenticatedError() {
        view?.showInfo(title: "Ошибка", message: "Вы не авторизированы")
    }
    func didReceiveUnauthorizedError() {
        view?.showInfo(title: "Ошибка", message: "У вас нет прав для совершения данной операции")
    }
    func didReceiveCancelledError() {
        view?.showInfo(title: "Отмена", message: "Операция отменена")
    }
    func didReceiveRetryLimitExceededError() {
        view?.showInfo(title: "Ошибка", message: "Лимит загрузок за сегодня превышен. Попробуйте позже")
    }
    func didReceiveInvalidEmailError() {
        view?.showInfo(title: "Ошибка", message: "Введен неверный или не существующий адрес почты")
    }
    func didReceiveUnverifiedEmail() {
        view?.showInfo(title: "Почта не подтверждена", message: "Зайдите на почту и пройдите по ссылке в письме верификации")
    }
    func didReceiveWrongPasswordError() {
        view?.showInfo(title: "Ошибка", message: "Неверный пароль")
    }
    func didReceiveUnknownError() {
        view?.showInfo(title: "Ошибка", message: "Неверный логин или пароль")
    }
    func didNotReceiveResult() {
        view?.showInfo(title: "Ошибка", message: "Данные с сервера не были получены")
    }
    func didSignOut() {
        view?.showInfo(title: "Выход", message: "Вы успешно вышли")
    }
}
