//
//  ProfilePresenter.swift
//  TindPet
//
//  Created by Aleksandr Derevenskih on 27.06.2023.
//

import UIKit

protocol ProfileViewProtocol: UIViewController {
    func showImagePicker()
    func showPets(pets: [PetModel])
    func setAvatarImge(avatat: UIImage)
}

final class ProfilePresenter {
    var view: ProfileViewProtocol?
    var coordinator: AppCoordinatorProtocol?
    var networkService: FirebaseServiceProtocol?
    private var myPets: [PetModel] = []
    private var selectedIndex = 0
}

extension ProfilePresenter: ProfilePresenterProtocol {
    func deletePet(index: IndexPath) {
        myPets.remove(at: index.row)
        view?.showPets(pets: myPets)
    }
    func addPetButtonAction() {
        let model = PetModel(name: nil, age: nil, icon: UIImage(named: "addPhoto1") ?? UIImage())
        myPets.insert(model, at: 0)
        view?.showPets(pets: myPets)
    }
    func pickedImage(image: UIImage) {
        switch selectedIndex {
        case 0:
            view?.setAvatarImge(avatat: image)
        default:
            myPets[selectedIndex - 2].icon = image
            view?.showPets(pets: myPets)
        }
    }
    func viewDidLoad() {
        //Загрузить данный пользователя
        view?.showPets(pets: myPets)
    }
    func selectedPetImage(index: IndexPath) {
        selectedIndex = index.row
        view?.showImagePicker()
    }
    func tabLogoutButton() {
        UserDefaults.standard.set(false, forKey: Key.isLogin)
        coordinator?.goToLoginVC(didTapLogout: true)
    }
}
