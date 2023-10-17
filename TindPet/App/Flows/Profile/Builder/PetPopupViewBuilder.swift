//
//  PetPopupViewBuilder.swift
//  TindPet
//
//  Created by Asya Checkanar on 13.10.2023.
//

import Foundation
import UIKit

enum PetPopupViewBuilder {
    static func build(coordinator: AppCoordinatorProtocol) -> UIViewController {
        let petService = PetService()
        let presenter = PetPopupPresenter(petService: petService)
        let controller = PetPopupViewController()
        presenter.view = controller
        presenter.coordinator = coordinator
        controller.presenter = presenter
        return controller
    }
}
