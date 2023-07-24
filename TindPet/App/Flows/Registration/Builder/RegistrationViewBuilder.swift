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
        let view = RegistrationViewController()
        presenter.view = view
        presenter.coordinator = coordinator
        view.presenter = presenter
        return view
    }
}
