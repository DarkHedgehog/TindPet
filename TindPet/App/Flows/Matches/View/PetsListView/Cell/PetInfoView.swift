//
//  PetInfoView.swift
//  TindPet
//
//  Created by Aleksandr Derevenskih on 08.08.2023.
//

import UIKit

class PetInfoView: UIView {
    private var petValue: PetInfoModel?

    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.fontBold
        label.textColor = Constants.fontBoldColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let locationLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.fontNormal
        label.textColor = Constants.fontNormalColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let ageLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.fontNormal
        label.textColor = Constants.fontNormalColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let genderImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    let genderLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.fontNormal
        label.textColor = Constants.fontNormalColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let stateLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.fontNormal
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let connectButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = Constants.connectButtonTitle
        config.baseBackgroundColor = .systemBlue
        config.cornerStyle = .large
        config.buttonSize = .small
        let button = UIButton(type: .roundedRect)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configuration = config
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        connectButton.addTarget(self, action: #selector(tapConnectButton), for: .touchUpInside)
        addViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func setPetModel(pet: PetInfoModel) {
        nameLabel.text = pet.name
        locationLabel.text = pet.location
        ageLabel.text = pet.ageText
        genderImage.image = pet.genderImage
        genderLabel.text = pet.gender
        stateLabel.text = pet.status
        stateLabel.textColor = pet.statusColor
        petValue = pet
    }

    @objc private func tapConnectButton() {
    }

    private func addViews() {
        addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: topAnchor),
            nameLabel.leftAnchor.constraint(equalTo: leftAnchor),
            nameLabel.rightAnchor.constraint(equalTo: rightAnchor)
        ])

        addSubview(locationLabel)
        NSLayoutConstraint.activate([
            locationLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: Constants.spaceBetweenLabels),
            locationLabel.leftAnchor.constraint(equalTo: leftAnchor),
            locationLabel.rightAnchor.constraint(equalTo: rightAnchor)
        ])

        addSubview(ageLabel)
        NSLayoutConstraint.activate([
            ageLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: Constants.spaceBetweenLabels),
            ageLabel.leftAnchor.constraint(equalTo: leftAnchor)
        ])

        addSubview(genderImage)
        NSLayoutConstraint.activate([
            genderImage.centerYAnchor.constraint(equalTo: ageLabel.centerYAnchor),
            genderImage.leftAnchor.constraint(equalTo: ageLabel.rightAnchor, constant: Constants.genderImageLeftPadding),
            genderImage.heightAnchor.constraint(equalToConstant: Constants.genderImageSize.height),
            genderImage.widthAnchor.constraint(equalToConstant: Constants.genderImageSize.width)
        ])

        addSubview(genderLabel)
        NSLayoutConstraint.activate([
            genderLabel.centerYAnchor.constraint(equalTo: ageLabel.centerYAnchor),
            genderLabel.leftAnchor.constraint(equalTo: genderImage.rightAnchor, constant: Constants.genderImageRightPadding)
        ])

        addSubview(stateLabel)
        NSLayoutConstraint.activate([
            stateLabel.topAnchor.constraint(equalTo: ageLabel.bottomAnchor, constant: Constants.stateLineTopPadding),
            stateLabel.leftAnchor.constraint(equalTo: leftAnchor)
        ])

        addSubview(connectButton)
        NSLayoutConstraint.activate([
            connectButton.centerYAnchor.constraint(equalTo: stateLabel.centerYAnchor),
            connectButton.leftAnchor.constraint(equalTo: stateLabel.rightAnchor, constant: 10)
        ])
    }

    enum Constants {
        static let nameLabelHeight: CGFloat = 20
        static let spaceBetweenLabels: CGFloat = 0
        static let fontBold = UIFont(name: "HelveticaNeue-Bold", size: 13.0)
        static let fontBoldColor: UIColor = .black
        static let fontNormal = UIFont(name: "HelveticaNeue", size: 13.0)
        static let fontNormalColor: UIColor = .gray
        static let genderImageSize = CGSize(width: 20, height: 20)
        static let genderImageLeftPadding: CGFloat = 10
        static let genderImageRightPadding: CGFloat = 5
        static let stateLineTopPadding: CGFloat = 10
        static let connectButtonTitle = "Связаться"
    }
}
