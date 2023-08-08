//
//  PetDetailViewController.swift
//  TindPet
//
//  Created by Aleksandr Derevenskih on 08.08.2023.
//

import UIKit

final class PetDetailViewController: UIViewController {
    var presenter: PetDetailPresenterProtocol?

    private var petValue: PetInfoModel?

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

    let petInfo: UIView & PetDetailViewProtocol = {
        let view = PetDetailInfo()
        view.backgroundColor = .white
        view.layer.masksToBounds = false
        view.layer.shadowOffset = CGSize(width: 5, height: 5)
        view.layer.cornerRadius = 10
        view.layer.shadowRadius = 5
        view.layer.shadowOpacity = 0.5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let userInfo: UserInfoView = {
        let view = UserInfoView()
        view.backgroundColor = .red
        view.layer.masksToBounds = false
        view.layer.shadowOffset = CGSize(width: 5, height: 5)
        view.layer.cornerRadius = 10
        view.layer.shadowRadius = 5
        view.layer.shadowOpacity = 0.5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let descriptionText: UILabel = {
        let label = UILabel()
        label.numberOfLines = 5
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        if let presenter = presenter {
            setPetModel(pet: presenter.getPetModel())
        }
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

        self.view.addSubview(petInfo)
        NSLayoutConstraint.activate([
            petInfo.centerYAnchor.constraint(equalTo: petImage.bottomAnchor),
            petInfo.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: Constants.infoXPadding),
            petInfo.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -Constants.infoXPadding),
            petInfo.heightAnchor.constraint(equalToConstant: Constants.infoHeight)
        ])

        self.view.addSubview(userInfo)
        NSLayoutConstraint.activate([
            userInfo.topAnchor.constraint(equalTo: petInfo.bottomAnchor, constant: 10),
            userInfo.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: Constants.infoXPadding),
            userInfo.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -Constants.infoXPadding),
            userInfo.heightAnchor.constraint(equalToConstant: Constants.userHeight)
        ])

        self.view.addSubview(descriptionText)
        NSLayoutConstraint.activate([
            descriptionText.topAnchor.constraint(equalTo: userInfo.bottomAnchor, constant: 10),
            descriptionText.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: Constants.infoXPadding),
            descriptionText.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -Constants.infoXPadding),
//            descriptionText.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    enum Constants {
        static let unsettedPetPhoto = UIImage(named: "person")!
        static let backButtonImage = UIImage(systemName: "arrow.left")
        static let infoXPadding = 30.0
        static let infoHeight = 120.0
        static let userHeight = 60.0
    }

}

extension PetDetailViewController: PetDetailViewProtocol {
    public func setPetModel(pet: PetInfoModel) {
        petValue = pet
        petImage.image = pet.photo
        descriptionText.text = pet.description ?? ""
        petInfo.setPetModel(pet: pet)
    }
}
