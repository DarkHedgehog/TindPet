//
//  ProfilePresenter.swift
//  TindPet
//
//  Created by Aleksandr Derevenskih on 27.06.2023.
//

import Foundation
import UIKit

protocol ProfileViewProtocol: UIViewController {
}

final class ProfilePresenter {
    var view: ProfileViewProtocol?
    var coordinator: AppCoordinatorProtocol?
    var networkService: FirebaseServiceProtocol?
}

extension ProfilePresenter: ProfilePresenterProtocol {
    func tabLogoutButton() {
        UserDefaults.standard.set(false, forKey: KeyConstants.isLogin)
        coordinator?.goToLoginVC(didTapLogout: true)
    }
}
