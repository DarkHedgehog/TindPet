//
//  SwipesViewBuilder.swift
//  TindPet
//
//  Created by Алексей on 10.07.2023.
//

import UIKit

enum SwipesViewBuilder {
    static func build() -> UIViewController {
        let swipeService = SwipeService() //SwipeStaticService()
        let petModelLoader = PetModelLoaderService()
        let presenter = SwipesPresenter(swipeService: swipeService, petModelLoader: petModelLoader)
        let view = SwipesViewController()
        view.presenter = presenter
        presenter.view = view
        return view
    }
}
