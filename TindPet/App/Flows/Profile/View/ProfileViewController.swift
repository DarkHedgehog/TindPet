//
//  ProfileView.swift
//  TindPet
//
//  Created by Aleksandr Derevenskih on 27.06.2023.
//

import UIKit

protocol ProfilePresenterProtocol {
    func onButtonTap()
}

final class ProfileViewController: UIViewController {
    var presenter: ProfilePresenterProtocol?
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
extension ProfileViewController: ProfileViewProtocol {
    func showLabelWith(text: String) {
    }
}
