//
//  MatchesViewPresenter.swift
//  TindPet
//
//  Created by Aleksandr Derevenskih on 07.08.2023.
//

import Foundation

protocol MatchesViewProtocol: AnyObject {
    func setPetList(pets: [PetInfoModel])
    func showInfo(title: String, message: String)
}

protocol MatchesPresenterProtocol {
    func setFilter(text: String, type: FilterPetType)
    func onPetSelected(value: PetInfoModel)
}

final class MatchesPresenter {
    var view: MatchesViewProtocol?
    var coordinator: AppCoordinatorProtocol?
    let service = MatchesStaticService()
    var matchService: MatchServiceProtocol
    
    init(view: MatchesViewProtocol? = nil, coordinator: AppCoordinatorProtocol? = nil, matchService: MatchServiceProtocol) {
        self.view = view
        self.coordinator = coordinator
        self.matchService = matchService
        self.matchService.delegate = self
    }
    
    func petInfoToModels(_ list: [PetInfo]) -> [PetInfoModel] {
        return list.map { PetInfoModel($0) }
    }
}

extension MatchesPresenter: MatchesPresenterProtocol {
    func onPetSelected(value: PetInfoModel) {
        matchService.getPetByID(petID: value.petID) { didLoad, pet in
            guard didLoad, let pet = pet else { return }
            self.coordinator?.goToPetDetail(pet)
        }
        service.getPetByID(petID: value.petID) { success, petInfo in
            if let petInfo = petInfo {
                self.coordinator?.goToPetDetail(petInfo)
            }
        }
    }

    func setFilter(text: String, type: FilterPetType) {
        matchService.getLikedPets { didLoad, pets in
            guard didLoad, let pets = pets else { return }
            DispatchQueue.main.async {
                let petModels = self.petInfoToModels(pets)
                self.view?.setPetList(pets: petModels)
            }
        }
//        service.getLikedPets { _, list in
//            DispatchQueue.main.async {
//                let petModels = self.petInfoToModels(list ?? [])
//                self.view?.setPetList(pets: petModels)
//            }
//        }
    }
}

extension MatchesPresenter: MatchServiceDelegate {
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
