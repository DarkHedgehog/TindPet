//
//  ProfileViewBuilder.swift
//  TindPet
//
//  Created by Aleksandr Derevenskih on 27.06.2023.
//

import Foundation
import UIKit

enum ProfileViewBuilder {
    static func build(coordinator: AppCoordinatorProtocol) -> UIViewController {
        let editService = EditService()
        let petService = PetService()
        let presenter = ProfilePresenter(editService: editService, petService: petService)
        let controller = ProfileViewController()
        presenter.view = controller
        presenter.coordinator = coordinator
        controller.presenter = presenter
        return controller
    }
}
