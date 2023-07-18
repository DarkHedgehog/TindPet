//
//  SwipesViewController.swift
//  TindPet
//
//  Created by Aleksandr Derevenskih on 21.06.2023.
//

import UIKit

protocol SwipesPresenterProtocol {
    func likeButtonAction()
    func dislikeButtonAction()
}

class SwipesViewController: UIViewController {
    var presenter: SwipesPresenterProtocol?

    private var swipeView: SwipesView {
        return self.view as! SwipesView
    }


    // MARK: - Init
    override func loadView() {
        super.loadView()
        self.view = SwipesView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension SwipesViewController: SwipeCardsDelegate {
    func likeButtonAction() {
        print("Like")
    }

    func dislikeButtonAction() {
        print("Dislike")
    }
}

extension SwipesViewController: SwipesViewProtocol {
}
