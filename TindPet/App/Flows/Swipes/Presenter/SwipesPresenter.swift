//
//  SwipesPresenter.swift
//  TindPet
//
//  Created by Алексей on 10.07.2023.
//

import UIKit

protocol SwipesViewProtocol {
}

class SwipesPresenter {
    var view: SwipesViewProtocol?
}

extension SwipesPresenter: SwipesPresenterProtocol {
    func likeButtonAction() {
    }
    
    func dislikeButtonAction() {
    }
}
