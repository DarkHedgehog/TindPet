//
//  PetDetailViewBuilder.swift
//  TindPet
//
//  Created by Aleksandr Derevenskih on 08.08.2023.
//

import UIKit

enum PetDetailViewBuilder {
    static func build(petId: String, coordinator: AppCoordinatorProtocol) -> UIViewController {
        let presenter = PetDetailPresenter(petId: petId)
        let view = PetDetailViewController()
        presenter.view = view
        presenter.coordinator = coordinator
        view.presenter = presenter
        return view
    }
}
