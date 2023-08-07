//
//  MatchesViewPresenter.swift
//  TindPet
//
//  Created by Aleksandr Derevenskih on 07.08.2023.
//

import Foundation

protocol MatchesViewProtocol: AnyObject {
}

protocol MatchesPresenterProtocol {
    func setFilter(text: String, type: FilterPetType)
}

final class MatchesPresenter {
    var view: MatchesViewProtocol?
    var coordinator: AppCoordinatorProtocol?
}

extension MatchesPresenter: MatchesPresenterProtocol {
    func setFilter(text: String, type: FilterPetType) {
        print("set filter string: \(text), pets: \(type)")
    }
}
