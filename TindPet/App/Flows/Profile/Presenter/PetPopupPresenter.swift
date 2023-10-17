//
//  PetPopupPresenter.swift
//  TindPet
//
//  Created by Asya Checkanar on 10.10.2023.
//

import Foundation
import UIKit

protocol PetPopupViewProtocol {
    func showImagePicker()
    func showInfo(title: String, message: String)
}

class PetPopupPresenter {
    var petService: PetServiceProtocol
    var coordinator: AppCoordinatorProtocol?
    var view: PetPopupViewProtocol?
    var pet: PetInfo?
    init(petService: PetServiceProtocol, coordinator: AppCoordinatorProtocol? = nil, view: PetPopupViewProtocol? = nil) {
        self.petService = petService
        self.coordinator = coordinator
        self.view = view
        self.petService.delegate = self
    }
}

extension PetPopupPresenter: PetPopupPresenterProtocol {
    func savePetButtonAction(petInfo: PetInfo?) {
        guard let petInfo = petInfo else { return }
        petService.addPet(petInfo: petInfo, photo: petInfo.image!) { didLoad in
            if didLoad {
                print("loaded pet")
            }
        }
    }
    func selectedPetImage() {
        view?.showImagePicker()
    }
    func pickedImage(image: UIImage) {
        pet?.image = image
    }
}

extension PetPopupPresenter: PetServiceDelegate {
    func didReceiveObjectNotFoundError() {
        view?.showInfo(title: "Ошибка", message: "Объект не найден")
    }
    func didReceiveUnauthenticatedError() {
        view?.showInfo(title: "Ошибка авторизации", message: "Вы не авторизированы")
    }
    func didReceiveUnauthorizedError() {
        view?.showInfo(title: "Ошибка", message: "У вас нет прав для совершения данной операции")
    }
    func didReceiveCancelledError() {
        view?.showInfo(title: "Отмена", message: "Операция отменена")
    }
    func didReceiveRetryLimitExceededError() {
        view?.showInfo(title: "Данные не отправлены", message: "Лимит на соединение превышен. Попробуйте позже")
    }
    func didReceiveDocumentAlreadyExistsError() {
        view?.showInfo(title: "Ошибка", message: "Объект уже существует")
    }
    func didReceiveDataLossError() {
        view?.showInfo(title: "Ошибка", message: "Данные утеряны")
    }
    func didReceiveUnavailableError() {
        view?.showInfo(title: "Ошибка соединения", message: "Сервис временно недоступен")
    }
    func didNotReceiveResult() {
        view?.showInfo(title: "Ошибка", message: "Данные с сервера не были получены")
    }
    func didReceiveUnknownError() {
        view?.showInfo(title: "Ошибка", message: "Неизвестная ошибка")
    }
}
