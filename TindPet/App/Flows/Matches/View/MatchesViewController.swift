//
//  MatchesViewController.swift
//  TindPet
//
//  Created by Aleksandr Derevenskih on 21.06.2023.
//

import UIKit

protocol PetFilterProtocol {
    func selectedFilterIndex() -> Int
}

final class MatchesViewController: UIViewController {
    var presenter: MatchesPresenterProtocol?

    let searchString: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = Constants.searchPlaceholder
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.layer.borderWidth = 0
        return searchBar
    }()

    let filterButtons: FilterViewController = {
        let controller = FilterViewController(values: Constants.filterLabels)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        return controller
    }()

    init() {
        super.init(nibName: nil, bundle: nil)
        filterButtons.delegate = self
        searchString.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        super.loadView()
        self.view = UIView()
        configureUI()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    private func configureUI() {
        self.view.backgroundColor = .systemBackground
        self.view.addSubview(searchString)
        NSLayoutConstraint.activate([
            searchString.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchString.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            searchString.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
        ])

        self.addChild(filterButtons)
        self.view.addSubview(filterButtons.view)

        NSLayoutConstraint.activate([
            filterButtons.view.topAnchor.constraint(equalTo: searchString.safeAreaLayoutGuide.bottomAnchor),
            filterButtons.view.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            filterButtons.view.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
        ])
    }

    enum Constants {
        static let searchPlaceholder = "Искать питомца..."
        static let filterLabels = ["Всех", "Кошку", "Cобаку"]
    }
}

extension MatchesViewController: MatchesViewProtocol {

}

extension MatchesViewController: FilterViewControllerDelegate {
    func onFilterChanged(value: Int) {
        let petsType = filterTypeByIndex(value)
        presenter?.setFilter(text: searchString.text ?? "", type: petsType)

        func filterTypeByIndex(_ value: Int) -> FilterPetType {
            switch value {
            case 1: return .cats
            case 2: return .dogs
            default: return .any
            }
        }
    }
}

extension MatchesViewController: UISearchBarDelegate {
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        onFilterChanged(value: filterButtons.selectedFilterIndex())
    }
}
