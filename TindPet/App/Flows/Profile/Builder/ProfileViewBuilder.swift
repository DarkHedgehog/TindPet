//
//  ProfileViewBuilder.swift
//  TindPet
//
//  Created by Aleksandr Derevenskih on 27.06.2023.
//

import Foundation
import UIKit

enum ProfileViewBuilder {
    static func build() -> UIViewController {
        let presenter = ProfilePresenter()
        let controller = ProfileViewController()
        presenter.view = controller
        controller.presenter = presenter
        return controller
    }
}
