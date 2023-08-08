//
//  PetDetailInfo.swift
//  TindPet
//
//  Created by Aleksandr Derevenskih on 08.08.2023.
//

import UIKit

class PetDetailInfo: UIView {
    private var petValue: PetInfoModel?

    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.fontBold
        label.textColor = Constants.fontBoldColor
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

    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addViews() {
        addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: Constants.labelTopOffset),
            nameLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: Constants.labelLeftOffset),
            nameLabel.rightAnchor.constraint(equalTo: rightAnchor)
        ])

        addSubview(genderImage)
        NSLayoutConstraint.activate([
            genderImage.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor),
            genderImage.rightAnchor.constraint(equalTo: rightAnchor, constant: -Constants.labelLeftOffset),
            genderImage.heightAnchor.constraint(equalToConstant: Constants.genderImageSize.height),
            genderImage.widthAnchor.constraint(equalToConstant: Constants.genderImageSize.width)
        ])

        addSubview(ageLabel)
        NSLayoutConstraint.activate([
            ageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.labelTopOffset),
            ageLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: Constants.labelLeftOffset)
        ])
    }

    enum Constants {
        static let nameLabelHeight: CGFloat = 20
        static let spaceBetweenLabels: CGFloat = 0
        static let fontBold = UIFont(name: "HelveticaNeue-Bold", size: 20.0)
        static let fontBoldColor: UIColor = .black
        static let fontNormal = UIFont(name: "HelveticaNeue", size: 16.0)
        static let fontNormalColor: UIColor = .gray
        static let genderImageSize = CGSize(width: 30, height: 30)
        static let genderImageLeftPadding: CGFloat = 10
        static let genderImageRightPadding: CGFloat = 5
        static let stateLineTopPadding: CGFloat = 10
        static let labelTopOffset: CGFloat = 20
        static let labelLeftOffset: CGFloat = 15
    } // San-francisco
}

extension PetDetailInfo: PetDetailViewProtocol {
    public func setPetModel(pet: PetInfoModel) {
        nameLabel.text = pet.name
        ageLabel.text = pet.ageText
        genderImage.image = pet.genderImage
        petValue = pet
    }
}
