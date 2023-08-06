//
//  ProfilePresenter.swift
//  TindPet
//
//  Created by Aleksandr Derevenskih on 27.06.2023.
//

import UIKit

protocol ProfileViewProtocol: UIViewController {
    func showImagePicker()
    func showPets(pets: [PetInfo])
    func setAvatarImage(avatar: UIImage)
    func showInfo(title: String, message: String)
    func reloadTableView()
}

final class ProfilePresenter {
    var editService: EditServiceProtocol
    var petService: PetServiceProtocol
    var view: ProfileViewProtocol?
    var coordinator: AppCoordinatorProtocol?
    var user = UserInfo()
    var pets: [PetInfo] = [PetInfo]()
    var avatar = UIImage()
    private var myPets: [PetModel] = []
    private var selectedIndex = 0
    init(editService: EditServiceProtocol, petService: PetServiceProtocol) {
        self.editService = editService
        self.petService = petService
        self.editService.delegate = self
        self.petService.delegate = self
    }
}

extension ProfilePresenter: ProfilePresenterProtocol {
    func savePetButtonAction(petInfo: PetInfo?) {
        guard let petInfo = petInfo else { return }
        petService.addPet(petInfo: petInfo, photo: petInfo.image!) { didLoad in
            if didLoad {
                print("loaded pet")
            }
        }
        //        self.view?.reloadTableView()
    }
    func tapEditButton() {
    }
    func tapSaveButton(name: String?, surname: String?) {
        guard let name = name, let surname = surname else { return }
        editService.updateCurrentUserData(name: name) { didLoad in
            if didLoad {
                self.user.name = name
            }
        }
        editService.updateCurrentUserData(surname: surname) { didLoad in
            if didLoad {
                self.user.surname = surname
            }
        }
        //        self.view?.reloadTableView()
    }
    func deletePet(index: IndexPath) {
        petService.deletePet(petID: pets[index.row].petID) { didDelete in
            if didDelete {
                self.pets.remove(at: index.row)
                self.view?.showPets(pets: self.pets)
            }
        }
        view?.showPets(pets: pets)
    }
    func addPetButtonAction() {
        let pet = PetInfo(name: "", image: UIImage(named: "addPhoto1") ?? UIImage())
        pets.insert(pet, at: 0)
        view?.showPets(pets: pets)
    }
    func pickedImage(image: UIImage) {
        switch selectedIndex {
        case 0:
            editService.updateCurrentUserData(image: image) { isUploaded in
                if isUploaded {
                    self.view?.setAvatarImage(avatar: image)
                    self.avatar = image
                    self.view?.reloadTableView()
                }
            }
        default:
            myPets[selectedIndex - 2].icon = image
            view?.showPets(pets: pets)
        }
    }
    func viewDidLoad() {
        editService.getCurrentUserInfo(completion: { isReceived, userInfo in
            guard isReceived, let userInfo = userInfo else {
                return
            }
            self.user = userInfo
            DispatchQueue.global().async {
                if let photoUrl = userInfo.photo,
                      let url = URL(string: photoUrl),
                   let data = try? Data(contentsOf: url) {
                    print("data exists")
                    DispatchQueue.main.async {
                        self.avatar = UIImage(data: data)!
                        print("got avatar")
                        self.view?.reloadTableView()
                        print("reloaded in dispatch")
                    }
                } else {
                    print("no photo")
                    self.avatar = UIImage(named: "addPhoto1") ?? UIImage()
                    self.view?.reloadTableView()
                    print("reloaded")
                }
            }
            self.view?.reloadTableView()
            print("reloaded outside")
        })
        petService.getPets { isReceived, petsInfo in
            guard isReceived, let pets = petsInfo else { return }
            self.pets = pets
            DispatchQueue.global().async {
                for i in self.pets.indices {
                    if let photoUrl = self.pets[i].photo,
                          let url = URL(string: photoUrl),
                       let data = try? Data(contentsOf: url) {
                        print("data exists")
                        DispatchQueue.main.async {
                            self.pets[i].image = UIImage(data: data)!
                            print("got avatar")
                            print("reloaded in dispatch")
                        }
                    }
                }
                self.view?.showPets(pets: pets)
            }
        }
        view?.showPets(pets: pets)
    }
    func selectedPetImage(index: IndexPath) {
        selectedIndex = index.row
        view?.showImagePicker()
    }
    func tapLogoutButton() {
        editService.signOut(completion: { signedOut in
            if signedOut {
                UserDefaults.standard.set(false, forKey: Key.isLogin)
                self.coordinator?.goToLoginVC(didTapLogout: true)
            }
        })
    }
}

extension ProfilePresenter: EditServiceDelegate {
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

extension ProfilePresenter: PetServiceDelegate {
}
