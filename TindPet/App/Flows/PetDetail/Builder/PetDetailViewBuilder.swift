//
//  PetDetailViewBuilder.swift
//  TindPet
//
//  Created by Aleksandr Derevenskih on 08.08.2023.
//

import UIKit

enum PetDetailViewBuilder {
    static func build(petInfo: PetInfo, coordinator: AppCoordinatorProtocol) -> UIViewController {
        let presenter = PetDetailPresenter(petInfo: petInfo)
        let view = PetDetailViewController()
        presenter.view = view
        presenter.coordinator = coordinator
        view.presenter = presenter
        return view
    }
}
