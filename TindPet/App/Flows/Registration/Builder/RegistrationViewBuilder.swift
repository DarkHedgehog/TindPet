//
//  RegistrationViewBuilder.swift
//  TindPet
//
//  Created by Артур Кондратьев on 06.07.2023.
//

import UIKit

enum RegistrationViewBuilder {
    static func build() -> UIViewController {
        let presenter = RegistrationPresenter()
        let networkService = FirebaseService()
        let view = RegistrationViewController(networkService: networkService)
        presenter.view = view
        view.presenter = presenter
        return view
    }
}
