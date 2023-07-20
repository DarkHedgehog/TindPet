//
//  RegistrationViewBuilder.swift
//  TindPet
//
//  Created by Артур Кондратьев on 06.07.2023.
//

import UIKit

enum RegistrationViewBuilder {
    static func build() -> UIViewController {
        let registrationService = RegistrationService()
        let presenter = RegistrationPresenter(registrationService: registrationService)
        let view = RegistrationViewController(registrationService: registrationService)
        presenter.view = view
        view.presenter = presenter
        return view
    }
}
