//
//  SwipesPresenter.swift
//  TindPet
//
//  Created by Алексей on 10.07.2023.
//

import Foundation
import UIKit

protocol SwipesViewProtocol {
    func showInfo(title: String, message: String)
    func showPet(pet: PetInfo)
    func updateData(pet: PetInfo, species: String, image: UIImage)
}

protocol SwipesPresenterProtocol {
    func viewDidLoad()
    func likeButtonAction()
    func dislikeButtonAction()
}

class SwipesPresenter {
    var view: SwipesViewProtocol?
    var swipeService: SwipeServiceProtocol
    var pets: [PetInfo] = [PetInfo]()
    var preference = 0
    var petIndex = 0
    var currentPetID = ""
    var petImage = UIImage()
    init(swipeService: SwipeServiceProtocol) {
        self.swipeService = swipeService
        self.swipeService.delegate = self
    }
}

extension SwipesPresenter: SwipesPresenterProtocol {
    func viewDidLoad() {
        swipeService.getUserPreference { isLoaded, preference in
            if isLoaded {
                guard let preference = preference else { return }
                self.preference = preference
            }
        }
        swipeService.getPets(preference: preference) { isLoaded, petsDocs in
            if isLoaded {
                guard let petDocs = petsDocs else {
                    return
                }
                self.pets = petDocs
                //turn urls into images
                //reload data
            }
        }
        guard let pet = swipeService.showNextPet(pets: pets, index: 0) else {
            print("no pets exist")
            return
        }
        DispatchQueue.main.async {
            self.view?.showPet(pet: pet)
        }
        currentPetID = pet.petID
    }
    func likeButtonAction() {
        print("Like")
        petIndex += 1
        swipeService.petLiked(petID: currentPetID)
        guard let pet = swipeService.showNextPet(pets: pets, index: petIndex) else {
            print("no pets exist")
            return
        }
        currentPetID = pet.petID
        DispatchQueue.main.async {
            self.view?.showPet(pet: pet)
        }
    }
    func dislikeButtonAction() {
        print("Dislike")
        petIndex += 1
        swipeService.petDisliked(petID: currentPetID)
        guard let pet = swipeService.showNextPet(pets: pets, index: petIndex) else {
            print("no pets exist")
            return
        }

        DispatchQueue.global().async {
            guard let photoUrl = pet.photo,
               let url = URL(string: photoUrl),
               let data = try? Data(contentsOf: url),
               let petImage = UIImage(data: data) else {
                print("no photo")
                self.petImage = UIImage(named: "addPhoto1") ?? UIImage()
                //reload data
                print("reloaded")
                DispatchQueue.main.async {
                    self.view?.showPet(pet: pet)
                }
                return
            }
            DispatchQueue.main.async {
                self.view?.updateData(
                    pet: pet,
                    species: Species.from(pet.species).localizedText(),
                    image: petImage
                )
            }
        }
        currentPetID = pet.petID
    }
}

extension SwipesPresenter: SwipeServiceDelegate {
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
        view?.showInfo(title: "Отмена", message: "Операция отменена")
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
