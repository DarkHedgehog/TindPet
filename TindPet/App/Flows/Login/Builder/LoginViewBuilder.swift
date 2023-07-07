//
//  LoginViewBuilder.swift
//  TindPet
//
//  Created by Артур Кондратьев on 06.07.2023.
//

import UIKit

enum LoginViewBuilder {
    static func build() -> UIViewController {
        let presenter = LoginPresenter()
        let view = LoginViewController()
        view.presenter = presenter
        presenter.view = view
        return view
    }
}
