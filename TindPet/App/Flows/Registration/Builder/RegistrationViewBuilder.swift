//
//  RegistrationViewBuilder.swift
//  TindPet
//
//  Created by Артур Кондратьев on 06.07.2023.
//

import UIKit

enum RegistrationViewBuilder {
    static func build(coordinator: AppCoordinatorProtocol) -> UIViewController {
        let presenter = RegistrationPresenter()
        let view = RegistrationViewController()
        let networkService = FirebaseService()
        presenter.view = view
        presenter.coordinator = coordinator
        presenter.networkService = networkService
        view.presenter = presenter
        return view
    }
}
