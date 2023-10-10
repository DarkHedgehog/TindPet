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
    // MARK: - Init
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
        showPet(pet: pet)
        swipeView.swipeView.petImageView.image = image
    }
    func showInfo(title: String, message: String) {
        showAlert(title: title, message: message)
    }
    func showPet(pet: PetInfo) {
        let speciesText = Species.from(pet.species).localizedText()
        swipeView.swipeView.petImageView.image = pet.image
        swipeView.swipeView.label.text =
        """
    \t\(pet.name), \(pet.age.toLocalizedAge())
    \t\(speciesText)
    """
    }
    func showActivityIndicator() {
        print("swipesVC")
        DispatchQueue.main.async {
            self.swipeView.swipeView.showActivityIndicator()
        }
    }
    
    func hideActivityIndicator() {
        print("swipesVC hide")
        DispatchQueue.main.async {
            self.swipeView.swipeView.hideActivityIndicator()
        }
    }
}
