//
//  SwipesPresenter.swift
//  TindPet
//
//  Created by Алексей on 10.07.2023.
//

import UIKit

protocol SwipesViewProtocol {
}

protocol SwipesPresenterProtocol {
    func likeButtonAction()
    func dislikeButtonAction()
}

class SwipesPresenter {
    var view: SwipesViewProtocol?
}

extension SwipesPresenter: SwipesPresenterProtocol {
    func likeButtonAction() {
        print("Like")
    }
    func dislikeButtonAction() {
        print("Dislike")
    }
}
