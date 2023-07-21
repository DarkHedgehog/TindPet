//
//  RegistrationViewBuilder.swift
//  TindPet
//
//  Created by Артур Кондратьев on 06.07.2023.
//

import UIKit

enum RegistrationViewBuilder {
    static func build(coordinator: AppCoordinatorProtocol) -> UIViewController {
        let registrationService = RegistrationService()
        let presenter = RegistrationPresenter(registrationService: registrationService)
        let view = RegistrationViewController(registrationService: registrationService)
        let networkService = FirebaseService()
        presenter.view = view
        presenter.coordinator = coordinator
        presenter.networkService = networkService
        view.presenter = presenter
        return view
    }
}
