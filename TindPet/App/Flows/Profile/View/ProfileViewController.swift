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

    private let testButton: UIButton = {
        let textButton = UIButton()
        textButton.setTitle("Profile", for: .normal)
//        textButton.textAlignment = .center
//        textButton.font = UIFont.systemFont(ofSize: 26.0)
//        textButton.textColor = .yellow
        textButton.translatesAutoresizingMaskIntoConstraints = false
        return textButton
    }()

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    @objc private func onButtonTap(sender: UIButton) {
        presenter?.onButtonTap()
    }

    private func configureUI() {
        view.addSubview(testButton)
        setupConstraints()

        testButton.addTarget(self, action: #selector(onButtonTap(sender:)), for: .touchUpInside)
    }

    private func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            testButton.topAnchor.constraint(equalTo: safeArea.topAnchor),
            testButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            testButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            testButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }
}

extension ProfileViewController: ProfileViewProtocol {
    func showLabelWith(text: String) {
        testButton.setTitle(text, for: .normal)
    }
}
