//
//  MatchesViewBuilder.swift
//  TindPet
//
//  Created by Aleksandr Derevenskih on 07.08.2023.
//

import Foundation
import UIKit

enum MatchesViewBuilder {
    static func build(coordinator: AppCoordinatorProtocol) -> UIViewController {
        let matchService = MatchService()
        let petModelLoader = PetModelLoaderService()
        let presenter = MatchesPresenter(matchService: matchService, petModelLoader: petModelLoader)
        let view = MatchesViewController()
        presenter.view = view
        presenter.coordinator = coordinator
        view.presenter = presenter
        return view
    }
}
