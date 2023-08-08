//
//  PetDetailViewController.swift
//  TindPet
//
//  Created by Aleksandr Derevenskih on 08.08.2023.
//

import UIKit

final class PetDetailViewController: UIViewController {
    var presenter: PetDetailPresenterProtocol?

    let petImage: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 18
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.image = Constants.unsettedPetPhoto
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    let backButton: UIButton = {
        let button = UIButton(type: .system)
        var config = UIButton.Configuration.filled()
        config.title = ""
        config.baseBackgroundColor = .white
        config.baseForegroundColor = .darkGray
        config.cornerStyle = .large
        config.buttonSize = .medium
        config.image = Constants.backButtonImage
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .systemGreen
        button.configuration = config
        return button
    }()


    init() {
        super.init(nibName: nil, bundle: nil)
        backButton.addTarget(self, action: #selector(tapBackButton), for: .touchUpInside)
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    @objc private func tapBackButton() {
        presenter?.goBack()
    }

    private func configureUI() {
        self.view.backgroundColor = .systemBackground
        self.view.backgroundColor = .red
        self.view.addSubview(petImage)
        NSLayoutConstraint.activate([
            petImage.topAnchor.constraint(equalTo: view.topAnchor),
            petImage.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            petImage.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            petImage.heightAnchor.constraint(equalTo: petImage.widthAnchor)
        ])

        self.view.addSubview(backButton)
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            backButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 10),
//            backButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            backButton.heightAnchor.constraint(equalTo: backButton.widthAnchor)
        ])


    }

    enum Constants {
        static let unsettedPetPhoto = UIImage(named: "person")!
        static let backButtonImage = UIImage(systemName: "arrow.left")
    }

}

extension PetDetailViewController: PetDetailViewProtocol {

}
