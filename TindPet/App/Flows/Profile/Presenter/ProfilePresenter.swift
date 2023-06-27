//
//  ProfilePresenter.swift
//  TindPet
//
//  Created by Aleksandr Derevenskih on 27.06.2023.
//

import Foundation
import UIKit

protocol ProfileViewProtocol: UIViewController {
    func showLabelWith(text: String)
}

final class ProfilePresenter {
    var view: ProfileViewProtocol?
//    private let apiService: APIService

    init() {
    }
}

extension ProfilePresenter: ProfilePresenterProtocol {
    func onButtonTap() {
        view?.showLabelWith(text: "gjfsdgk dsgsfdsh dfs hdfsh")
        view?.navigationController?.pushViewController(ProfileViewBuilder.build(), animated: true)
    }
}
