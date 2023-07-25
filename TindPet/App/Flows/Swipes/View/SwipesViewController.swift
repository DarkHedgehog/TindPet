//
//  SwipesViewController.swift
//  TindPet
//
//  Created by Aleksandr Derevenskih on 21.06.2023.
//

import UIKit

class SwipesViewController: UIViewController {
    
    var presenter: SwipesPresenterProtocol? {
        didSet {
            swipeView.presenter = self.presenter
        }
    }

    private var swipeView: SwipesView {
        return self.view as! SwipesView
    }

    
    //MARK: - Init
    override func loadView() {
        super.loadView()
        self.view = SwipesView()
    }
 
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension SwipesViewController: SwipesViewProtocol {
}

