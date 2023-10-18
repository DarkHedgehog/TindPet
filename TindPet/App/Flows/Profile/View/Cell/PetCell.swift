//
//  PetCell.swift
//  TindPet
//
//  Created by Артур Кондратьев on 21.07.2023.
//

import UIKit

protocol PetCellDelegate: AnyObject {
    func tapPetPhoto(from cell: UITableViewCell)
    func savePetButtonAction()
}

class PetCell: UITableViewCell {
    // MARK: - Properties
    static let identifier = "PetCell"
    weak var delegate: PetCellDelegate?
    // MARK: - Subviews
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
    lazy var tfName: UITextField = {
        let tfName = UITextField()
        tfName.translatesAutoresizingMaskIntoConstraints = false
        tfName.placeholder = "Введите имя"
        return tfName
    }()
    lazy var tfAge: UITextField = {
        let tfAge = UITextField()
        tfAge.translatesAutoresizingMaskIntoConstraints = false
        tfAge.placeholder = "Введите возраст"
        tfAge.keyboardType = .numberPad
        return tfAge
    }()
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18)
        label.textColor = .black
        label.numberOfLines = 0
        label.text = "Name"
        return label
    }()
    lazy var ageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18)
        label.textColor = .black
        label.numberOfLines = 0
        label.text = "Age"
        return label
    }()
    lazy var speciesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18)
        label.textColor = .systemGray
        label.numberOfLines = 0
        label.text = "Species"
        return label
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
    lazy var lineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray5
        return view
    }()
//    lazy var savePetButton: UIButton = {
//        var config = UIButton.Configuration.filled()
////        config.title = "Сохранить"
//        config.baseBackgroundColor = .systemGray2
//        config.imagePlacement = .all
//        config.imagePadding = 8.0
//        config.cornerStyle = .medium
//        let button = UIButton(type: .roundedRect)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.configuration = config
//        button.setTitle("Save", for: .normal)
//        button.titleLabel?.font = .systemFont(ofSize: 10)
//        button.addTarget(self, action: #selector(tapSavePetButton), for: .touchUpInside)
//        return button
//    }()
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        petPhotoImageView.image = UIImage(named: "addPhoto1")
        tfName.text = nil
        tfAge.text = nil
    }
    // MARK: - Configure
    func configure(model: PetInfo) {
            nameLabel.text = model.name
        ageLabel.text = model.age.description
        if model.species == 0 {
            speciesLabel.text = "Кошка"
        } else {
            speciesLabel.text = "Собака"
        }
        
        petPhotoImageView.image = model.image
    }
    @objc private func tapPhotoImage() {
        delegate?.tapPetPhoto(from: self)
    }
    @objc private func tapSavePetButton() {
        delegate?.savePetButtonAction()
    }
    // MARK: - UI
    private func setUI() {
        contentView.addSubview(petPhotoImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(ageLabel)
        contentView.addSubview(speciesLabel)
//        contentView.addSubview(tfName)
//        contentView.addSubview(tfAge)
//        contentView.addSubview(segmentControl)
//        contentView.addSubview(savePetButton)
        contentView.addSubview(lineView)
        NSLayoutConstraint.activate([
            petPhotoImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            petPhotoImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 8),
            petPhotoImageView.widthAnchor.constraint(equalToConstant: 100),
            petPhotoImageView.heightAnchor.constraint(equalToConstant: 100),
            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            nameLabel.leftAnchor.constraint(equalTo: petPhotoImageView.rightAnchor, constant: 16),
            nameLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
            nameLabel.heightAnchor.constraint(equalToConstant: 20),
            ageLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 16),
            ageLabel.leftAnchor.constraint(equalTo: petPhotoImageView.rightAnchor, constant: 16),
            ageLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
            ageLabel.heightAnchor.constraint(equalToConstant: 20),
            speciesLabel.topAnchor.constraint(equalTo: ageLabel.bottomAnchor, constant: 16),
            speciesLabel.leftAnchor.constraint(equalTo: petPhotoImageView.rightAnchor, constant: 16),
            speciesLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
            speciesLabel.heightAnchor.constraint(equalToConstant: 20),
            speciesLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            lineView.bottomAnchor.constraint(equalTo: bottomAnchor),
            lineView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            lineView.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
            lineView.heightAnchor.constraint(equalToConstant: 2)
            ])
//        NSLayoutConstraint.activate([
//            petPhotoImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
//            petPhotoImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 8),
//            petPhotoImageView.widthAnchor.constraint(equalToConstant: 100),
//            petPhotoImageView.heightAnchor.constraint(equalToConstant: 100),
//            tfName.topAnchor.constraint(equalTo: topAnchor, constant: 8),
//            tfName.leftAnchor.constraint(equalTo: petPhotoImageView.rightAnchor, constant: 16),
//            tfName.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
//            tfName.heightAnchor.constraint(equalToConstant: 20),
//            tfAge.topAnchor.constraint(equalTo: tfName.bottomAnchor, constant: 16),
//            tfAge.leftAnchor.constraint(equalTo: petPhotoImageView.rightAnchor, constant: 16),
//            tfAge.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
//            tfAge.heightAnchor.constraint(equalToConstant: 20),
//            segmentControl.topAnchor.constraint(equalTo: tfAge.bottomAnchor, constant: 8),
//            segmentControl.leftAnchor.constraint(equalTo: petPhotoImageView.rightAnchor, constant: 16),
//            segmentControl.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
//            segmentControl.heightAnchor.constraint(equalToConstant: 28),
//            savePetButton.topAnchor.constraint(equalTo: segmentControl.bottomAnchor, constant: 8),
//            savePetButton.leftAnchor.constraint(equalTo: petPhotoImageView.rightAnchor, constant: 16),
//            savePetButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
//            savePetButton.heightAnchor.constraint(equalToConstant: 30),
//            savePetButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
//            lineView.bottomAnchor.constraint(equalTo: bottomAnchor),
//            lineView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
//            lineView.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
//            lineView.heightAnchor.constraint(equalToConstant: 2)
//        ])
    }
}
