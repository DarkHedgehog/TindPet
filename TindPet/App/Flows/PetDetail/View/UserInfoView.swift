//
//  UserInfoView.swift
//  TindPet
//
//  Created by Aleksandr Derevenskih on 08.08.2023.
//

import UIKit

final class UserInfoView: UIView {
    private var petValue: PetInfoModel?

    let userImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.layer.cornerRadius = 5
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.fontBold
        label.textColor = Constants.fontBoldColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let ownerLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.fontNormal
        label.textColor = Constants.fontNormalColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()


    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addViews() {
        addSubview(userImage)
        NSLayoutConstraint.activate([
            userImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            userImage.leftAnchor.constraint(equalTo: leftAnchor, constant: Constants.leftOffset),
            userImage.heightAnchor.constraint(equalTo: heightAnchor, constant: -Constants.yOffset * 2),
            userImage.widthAnchor.constraint(equalTo: heightAnchor, constant: -Constants.yOffset * 2)
        ])

        addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: Constants.labelTopOffset),
            nameLabel.leftAnchor.constraint(equalTo: userImage.rightAnchor, constant: Constants.leftOffset),
            nameLabel.rightAnchor.constraint(equalTo: rightAnchor)
        ])

        addSubview(ownerLabel)
        NSLayoutConstraint.activate([
            ownerLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: Constants.labelTopOffset),
            ownerLabel.leftAnchor.constraint(equalTo: userImage.rightAnchor, constant: Constants.leftOffset),
            nameLabel.rightAnchor.constraint(equalTo: rightAnchor)
        ])
    }

    enum Constants {
        static let leftOffset: CGFloat = 5
        static let yOffset: CGFloat = 2
        static let labelTopOffset: CGFloat = 5
        static let fontBold = UIFont.boldSystemFont(ofSize: 20)
        static let fontBoldColor: UIColor = .black
        static let fontNormal = UIFont.systemFont(ofSize: 16)
        static let fontNormalColor: UIColor = .gray
        static let ownerLabelText = "Владелец"
    }
}


extension UserInfoView: PetDetailViewProtocol {
    public func setPetModel(pet: PetInfoModel) {
        nameLabel.text = pet.ownerName
        ownerLabel.text = Constants.ownerLabelText
        userImage.image = pet.ownerPhoto
        petValue = pet
    }
}
