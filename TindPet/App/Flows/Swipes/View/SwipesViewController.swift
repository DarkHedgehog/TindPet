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
        showActivityIndicator()
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
        DispatchQueue.main.async {
            self.swipeView.loadingView = UIView()
            self.swipeView.loadingView.frame = CGRect(x: 0.0, y: 0.0, width: 100.0, height: 100.0)
            self.swipeView.loadingView.center = self.swipeView.center
            self.swipeView.loadingView.backgroundColor = UIColor.clear
            self.swipeView.loadingView.alpha = 0.7
            self.swipeView.loadingView.clipsToBounds = true
            self.swipeView.loadingView.layer.cornerRadius = 1
           
            self.swipeView.spinner = UIActivityIndicatorView(style: .large)
            self.swipeView.spinner.frame = CGRect(x: 0.0, y: 0.0, width: 80.0, height: 80.0)
            self.swipeView.spinner.center = CGPoint(x:self.swipeView.loadingView.bounds.size.width / 2, y: self.swipeView.loadingView.bounds.size.height / 2)
           
            self.swipeView.loadingView.addSubview(self.swipeView.spinner)
            self.swipeView.addSubview(self.swipeView.loadingView)
            self.swipeView.showActivityIndicator()
        }
    }
    
    func hideActivityIndicator() {
        DispatchQueue.main.async {
            self.swipeView.loadingView.removeFromSuperview()
            self.swipeView.swipeView.hideActivityIndicator()
        }
    }
}
