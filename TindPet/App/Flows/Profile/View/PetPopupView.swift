//
//  PetPopupView.swift
//  TindPet
//
//  Created by Asya Checkanar on 10.10.2023.
//

import UIKit

protocol PetPopupViewDelegate {
    func tapPetPhoto()
    func savePetButtonAction()
    func discardPetButtonAction()
}

class PetPopupView: UIView {
    var delegate: PetPopupViewDelegate?
    var petPhotoImageView: UIImageView = {
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapPhotoImage))
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "addPhoto1")
        imageView.isUserInteractionEnabled = true
//        imageView.addGestureRecognizer(tapGesture)
        return imageView
    }()
    
    var container: UIView = {
      let cont = UIView()
        cont.translatesAutoresizingMaskIntoConstraints = false
        cont.backgroundColor = .white
        cont.layer.cornerRadius = 10
        return cont
    }()
    
//    lazy var petNameLabel: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.textColor = .black
//        label.font = .boldSystemFont(ofSize: 36)
//        label.textAlignment = .center
//        label.text = "Имя питомца"
//        label.adjustsFontSizeToFitWidth = true
//        return label
//    }()

    var petNameTextField = {
        let textF = UITextField()
        textF.translatesAutoresizingMaskIntoConstraints = false
        textF.borderStyle = .roundedRect
        textF.backgroundColor = .white
        textF.clearButtonMode = .whileEditing
        textF.autocapitalizationType = .none
        textF.keyboardType = .default
        textF.placeholder = "Введите имя питомца"
        textF.font = UIFont.boldSystemFont(ofSize: 16)
        return textF
    }()
    
//    lazy var petAgeLabel: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.textColor = .black
//        label.font = .boldSystemFont(ofSize: 36)
//        label.textAlignment = .center
//        label.text = "Возраст"
//        label.adjustsFontSizeToFitWidth = true
//        return label
//    }()

    var petAgeTextField = {
        let textF = UITextField()
        textF.translatesAutoresizingMaskIntoConstraints = false
        textF.borderStyle = .roundedRect
        textF.backgroundColor = .white
        textF.clearButtonMode = .whileEditing
        textF.autocapitalizationType = .none
        textF.keyboardType = .numberPad
        textF.placeholder = "Введите возраст питомца"
        textF.font = UIFont.boldSystemFont(ofSize: 16)
        return textF
    }()
    
    var segmentControl: UISegmentedControl = {
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
    
    var savePetButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .systemGray2
        config.imagePlacement = .all
        config.imagePadding = 8.0
        config.cornerStyle = .medium
        let button = UIButton(type: .roundedRect)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configuration = config
        button.setTitle("Save", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 10)
        return button
    }()
    var discardPetButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .systemGray2
        config.imagePlacement = .all
        config.imagePadding = 8.0
        config.cornerStyle = .medium
        let button = UIButton(type: .roundedRect)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configuration = config
        button.setTitle("Discard", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 10)
        return button
    }()
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
    }
 // MARK: - Methods
    @objc private func tapPhotoImage() {
        delegate?.tapPetPhoto()
    }
    @objc private func tapSavePetButton() {
        delegate?.savePetButtonAction()
    }
    @objc private func tapDiscardPetButton() {
        delegate?.discardPetButtonAction()
    }
    func configureView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapPhotoImage))
        petPhotoImageView.addGestureRecognizer(tapGesture)
        discardPetButton.addTarget(self, action: #selector(tapDiscardPetButton), for: .touchUpInside)
        savePetButton.addTarget(self, action: #selector(tapSavePetButton), for: .touchUpInside)
    }
    func configureText(pet: PetInfo) {
        petNameTextField.text = pet.name
        petAgeTextField.text = String(pet.age)
        if pet.species == 1 {
            segmentControl.selectedSegmentIndex = 1
        }
        petPhotoImageView.image = pet.image
    }

    func configureUI() {
        self.backgroundColor = .systemBackground
//        self.addSubview(container)
        self.addSubview(petPhotoImageView)
        self.addSubview(petNameTextField)
        self.addSubview(petAgeTextField)
        self.addSubview(segmentControl)
//        self.addSubview(discardPetButton)
        self.addSubview(savePetButton)
        
//        container.addSubview(petPhotoImageView)
//        container.addSubview(petNameTextField)
//        container.addSubview(petAgeTextField)
//        container.addSubview(segmentControl)
//        container.addSubview(discardPetButton)
//        container.addSubview(savePetButton)
        NSLayoutConstraint.activate([
//                container.centerYAnchor.constraint(equalTo: self.centerYAnchor),
//                container.centerXAnchor.constraint(equalTo: self.centerXAnchor),
//                container.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8),
//                container.heightAnchor.constraint(equalToConstant: 150),
                petPhotoImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                petPhotoImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
//                petPhotoImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
                petPhotoImageView.widthAnchor.constraint(equalToConstant: 150),
                petPhotoImageView.heightAnchor.constraint(equalToConstant: 150),
                petNameTextField.topAnchor.constraint(equalTo: petPhotoImageView.bottomAnchor, constant: 30),
                petNameTextField.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20),
                petNameTextField.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16),
                petNameTextField.heightAnchor.constraint(equalToConstant: 40),
                petAgeTextField.topAnchor.constraint(equalTo: petNameTextField.bottomAnchor, constant: 16),
    //            petAgeTextField.centerYAnchor.constraint(equalTo: petPhotoImageView.centerYAnchor),
                petAgeTextField.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
                petAgeTextField.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16),
                petAgeTextField.heightAnchor.constraint(equalToConstant: 40),
                segmentControl.topAnchor.constraint(equalTo: petAgeTextField.bottomAnchor, constant: 16),
                segmentControl.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
                segmentControl.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16),
                segmentControl.heightAnchor.constraint(equalToConstant: 40),
//                discardPetButton.topAnchor.constraint(equalTo: segmentControl.bottomAnchor, constant: 8),
//                discardPetButton.leftAnchor.constraint(equalTo: petPhotoImageView.rightAnchor, constant: 16),
//                discardPetButton.rightAnchor.constraint(equalTo: petAgeTextField.rightAnchor, constant: -90),
//                discardPetButton.heightAnchor.constraint(equalToConstant: 30),
//                discardPetButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8),
                savePetButton.topAnchor.constraint(equalTo: segmentControl.bottomAnchor, constant: 16),
                savePetButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
                savePetButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16),
                savePetButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}
