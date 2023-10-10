//
//  PetPopupView.swift
//  TindPet
//
//  Created by Asya Checkanar on 10.10.2023.
//

import UIKit

protocol PetPopupDelegate {
    func tapPetPhoto(from cell: UITableViewCell)
    func savePetButtonAction()
}

class PetPopupView: UIView {
    
    lazy var petPhotoImageView: UIImageView = {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapPhotoImage))
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "addPhoto1")
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGesture)
        return imageView
    }()
    
    lazy var petNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 36)
        label.textAlignment = .center
        label.text = "Имя питомца"
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    lazy var petNameTextField = {
        let textF = UITextField()
        textF.translatesAutoresizingMaskIntoConstraints = false
        textF.borderStyle = .none
        textF.backgroundColor = .white
        textF.clearButtonMode = .whileEditing
        textF.autocapitalizationType = .none
        textF.keyboardType = .default
        textF.placeholder = "Введите имя"
        textF.font = UIFont.boldSystemFont(ofSize: 16)
        return textF
    }()
    
    lazy var petAgeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 36)
        label.textAlignment = .center
        label.text = "Возраст"
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    lazy var petAgeTextField = {
        let textF = UITextField()
        textF.translatesAutoresizingMaskIntoConstraints = false
        textF.borderStyle = .none
        textF.backgroundColor = .white
        textF.clearButtonMode = .whileEditing
        textF.autocapitalizationType = .none
        textF.keyboardType = .numbersAndPunctuation
        textF.placeholder = "Введите возраст"
        textF.font = UIFont.boldSystemFont(ofSize: 16)
        return textF
    }()
    
    lazy var segmentControl: UISegmentedControl = {
        let segment = UISegmentedControl(items: [Species.cat.localizedText(), Species.dog.localizedText()])
        let attributes = [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18),
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]
        segment.setTitleTextAttributes(attributes, for: .normal)
        segment.selectedSegmentTintColor = .systemGreen
        segment.selectedSegmentIndex = 0
        segment.translatesAutoresizingMaskIntoConstraints = false
        return segment
    }()
    
    lazy var savePetButton: UIButton = {
        var config = UIButton.Configuration.filled()
//        config.title = "Сохранить"
        config.baseBackgroundColor = .systemGray2
        config.imagePlacement = .all
        config.imagePadding = 8.0
        config.cornerStyle = .medium
        let button = UIButton(type: .roundedRect)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configuration = config
        button.setTitle("Save", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 10)
        button.addTarget(self, action: #selector(tapSavePetButton), for: .touchUpInside)
        return button
    }()
 // MARK: - Methods
    @objc private func tapPhotoImage() {
//        delegate?.tapPetPhoto(from: self)
    }
    @objc private func tapSavePetButton() {
//        delegate?.savePetButtonAction()
    }

    func configureUI() {
        self.addSubview(petPhotoImageView)
        self.addSubview(petNameLabel)
        self.addSubview(petNameTextField)
        self.addSubview(petAgeLabel)
        self.addSubview(petAgeTextField)
        self.addSubview(segmentControl)
        self.addSubview(savePetButton)
        NSLayoutConstraint.activate([])
    }
}
