//
//  PetCollectionViewCell.swift
//  TindPet
//
//  Created by Aleksandr Derevenskih on 08.08.2023.
//

import UIKit

class PetCollectionViewCell: UICollectionViewCell {
    private var petValue: PetCellModel?

    let petImage: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 18
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    let petInfo: PetInfoView = {
        let view = PetInfoView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func setPetModel(pet: PetCellModel) {
        petValue = pet
        petImage.image = pet.photo
        petInfo.setPetModel(pet: pet)
//        profileImageButton.setImage(pet.image, for: .normal)
    }

    private func addViews() {
        addSubview(petImage)
        NSLayoutConstraint.activate([
            petImage.topAnchor.constraint(equalTo: topAnchor),
            petImage.leftAnchor.constraint(equalTo: leftAnchor),
            petImage.heightAnchor.constraint(equalTo: heightAnchor),
            petImage.widthAnchor.constraint(equalTo: heightAnchor)
        ])

        addSubview(petInfo)
        NSLayoutConstraint.activate([
            petInfo.topAnchor.constraint(equalTo: topAnchor, constant: 30),
//            petInfo.centerYAnchor.constraint(equalTo: petImage.centerYAnchor),
            petInfo.leftAnchor.constraint(equalTo: petImage.rightAnchor, constant: 10),
            petInfo.rightAnchor.constraint(equalTo: rightAnchor, constant: 10),
            petInfo.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
