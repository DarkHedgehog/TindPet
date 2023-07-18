//
//  LoginViewBuilder.swift
//  TindPet
//
//  Created by Артур Кондратьев on 06.07.2023.
//

import UIKit

enum LoginViewBuilder {
    static func build(coordinator: AppCoordinatorProtocol) -> UIViewController {
        let presenter = LoginPresenter()
        let view = LoginViewController()
        let networkService = FirebaseService()
        view.presenter = presenter
        presenter.view = view
        presenter.coordinator = coordinator
        presenter.networkService = networkService
        return view
    }
}
