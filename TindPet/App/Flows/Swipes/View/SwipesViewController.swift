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
        presenter?.viewDidLoad()
    }
}

extension SwipesViewController: SwipesViewProtocol {
    func updateData(pet: PetInfo, species: String, image: UIImage) {
        swipeView.swipeView.thumbImageView.image = image ?? UIImage()
        swipeView.swipeView.label.text =
        """
    \(pet.name), \(pet.age)
    \(species)
    """
    }
    func showInfo(title: String, message: String) {
        showAlert(title: title, message: message)
    }
    func showPet(pet: PetInfo) {
        let species: String
        if pet.species == 0 {
            species = "Кошка"
        } else {
            species = "Собака"
        }
//        swipeView.swipeView.thumbImageView.image = presenter?.petImage ?? UIImage()
        swipeView.swipeView.label.text =
        """
    \(pet.name), \(pet.age)
    \(species)
    """
    }
}
