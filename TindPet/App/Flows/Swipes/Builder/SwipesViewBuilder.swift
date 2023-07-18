//
//  SwipesViewBuilder.swift
//  TindPet
//
//  Created by Алексей on 10.07.2023.
//

import UIKit

enum SwipesViewBuilder {
    static func build() -> UIViewController {
        let presenter = SwipesPresenter()
        let view = SwipesViewController()
        view.presenter = presenter
        presenter.view = view
        return view
    }
}
