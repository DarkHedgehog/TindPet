//
//  AccountInfoCell.swift
//  TindPet
//
//  Created by Артур Кондратьев on 19.07.2023.
//

import UIKit

protocol AccountInfoCellDelegate: AnyObject {
    func addPetButtonAction()
    func tapEditButton()
    func tapSaveButton()
}

class AccountInfoCell: UITableViewCell {
    static let identifier = "AccountInfoCell"
    weak var delegate: AccountInfoCellDelegate?
    // MARK: - Subviews
    lazy var nameSurnameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 24)
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .left
        label.textColor = .black
        label.text = "Карина Осипова"
        return label
    }()
    lazy var editNameSurnameButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.image = UIImage(
            systemName: "square.and.pencil",
            withConfiguration: UIImage.SymbolConfiguration(scale: .large))
        config.baseBackgroundColor = .systemGray2
        config.imagePlacement = .all
        config.imagePadding = 8.0
        config.cornerStyle = .medium
        let button = UIButton(type: .roundedRect)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configuration = config
        button.addTarget(self, action: #selector(tapEditButton), for: .touchUpInside)
        return button
    }()
    lazy var saveButton: UIButton = {
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
        button.addTarget(self, action: #selector(tapSaveButton), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    lazy var nameTextField: UITextField = {
        let textF = UITextField()
        textF.translatesAutoresizingMaskIntoConstraints = false
        textF.borderStyle = .none
        textF.placeholder = "Имя"
        textF.backgroundColor = .white
        textF.clearButtonMode = .whileEditing
        textF.keyboardType = .default
        textF.textContentType = .givenName
        textF.autocapitalizationType = .none
        textF.font = UIFont.boldSystemFont(ofSize: 16)
        textF.isHidden = true
        textF.backgroundColor = .systemGray6
        return textF
    }()
    lazy var surnameTextField: UITextField = {
        let textF = UITextField()
        textF.translatesAutoresizingMaskIntoConstraints = false
        textF.borderStyle = .none
        textF.placeholder = "Фамилия"
        textF.backgroundColor = .white
        textF.clearButtonMode = .whileEditing
        textF.keyboardType = .default
        textF.textContentType = .familyName
        textF.autocapitalizationType = .none
        textF.font = UIFont.boldSystemFont(ofSize: 16)
        textF.isHidden = true
        textF.backgroundColor = .systemGray6
        return textF
    }()
    lazy var locationButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "location"), for: .normal)
        button.tintColor = .systemGreen
        return button
    }()
    lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18)
        label.textColor = .systemGray
        label.numberOfLines = 0
        label.text = "Челябинск, Россия"
        return label
    }()
    lazy var searchLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = .black
        label.text = "Ищу:"
        return label
    }()
    lazy var segmentControl: UISegmentedControl = {
        let segment = UISegmentedControl(items: ["Всех", "Кошку", "Cобаку"])
        let attributes =
        [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 24),
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]
        segment.setTitleTextAttributes(attributes, for: .normal)
        segment.selectedSegmentTintColor = .topGradientColor
        segment.selectedSegmentIndex = 0
        segment.translatesAutoresizingMaskIntoConstraints = false
        return segment
    }()
    lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = .black
        label.text = "Контакты"
        return label
    }()
    lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 14)
        label.textColor = .black
        label.numberOfLines = 0
        label.text = "Адрес: Россия, Челябинск, Загорская, 60"
        return label
    }()
    lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 14)
        label.textColor = .black
        label.text = "Email: Osipova1260@gmail.com"
        return label
    }()
    lazy var lineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGreen
        return view
    }()
    lazy var addPetButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.image = UIImage(
            systemName: "plus.bubble.fill",
            withConfiguration: UIImage.SymbolConfiguration(scale: .large))
        config.title = "AddPet"
        config.baseBackgroundColor = .systemGreen
        config.imagePlacement = .trailing
        config.imagePadding = 8.0
        config.cornerStyle = .medium
        let button = UIButton(type: .roundedRect)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configuration = config
        button.addTarget(self, action: #selector(tapAddButton), for: .touchUpInside)
        return button
    }()
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Configure
    func configure(userInfo: UserInfo) {
        nameSurnameLabel.text = "\(userInfo.name) \(userInfo.surname)"
        emailLabel.text = userInfo.email
        segmentControl.selectedSegmentIndex = userInfo.preference
    }
    func addConstraints() {
//        NSLayoutConstraint.activate([constraints])
    }
    func deleteConstraints() {
//        obfef.removeConstraint(constraint)
    }
    @objc private func tapAddButton() {
        delegate?.addPetButtonAction()
    }
    @objc private func tapEditButton() {
        nameTextField.isHidden = false
        surnameTextField.isHidden = false
        saveButton.isHidden = false
        editNameSurnameButton.isHidden = true
        nameSurnameLabel.isHidden = true
    }
    @objc private func tapSaveButton() {
        nameTextField.isHidden = true
        surnameTextField.isHidden = true
        saveButton.isHidden = true
        editNameSurnameButton.isHidden = false
        nameSurnameLabel.isHidden = false
    }
    // MARK: - UI
    private func setUI() {
        backgroundColor = .systemBackground
        contentView.addSubview(editNameSurnameButton)
        contentView.addSubview(saveButton)
        contentView.addSubview(nameTextField)
        contentView.addSubview(surnameTextField)
        contentView.addSubview(nameSurnameLabel)
        contentView.addSubview(locationButton)
        contentView.addSubview(locationLabel)
        contentView.addSubview(searchLabel)
        contentView.addSubview(segmentControl)
        contentView.addSubview(infoLabel)
        contentView.addSubview(addressLabel)
        contentView.addSubview(emailLabel)
        contentView.addSubview(lineView)
        contentView.addSubview(addPetButton)
        NSLayoutConstraint.activate([
            editNameSurnameButton.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            editNameSurnameButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
            editNameSurnameButton.heightAnchor.constraint(equalToConstant: 30),
            editNameSurnameButton.widthAnchor.constraint(equalToConstant: 30),
            saveButton.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            saveButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
            saveButton.heightAnchor.constraint(equalToConstant: 30),
            saveButton.widthAnchor.constraint(equalToConstant: 70),
            nameSurnameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            nameSurnameLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            nameSurnameLabel.rightAnchor.constraint(equalTo: editNameSurnameButton.leftAnchor, constant: -16),
            nameTextField.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            nameTextField.heightAnchor.constraint(equalToConstant: 30),
            nameTextField.widthAnchor.constraint(equalToConstant: 120),
            nameTextField.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            nameTextField.rightAnchor.constraint(equalTo: surnameTextField.leftAnchor, constant: -10),
            surnameTextField.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            surnameTextField.heightAnchor.constraint(equalToConstant: 30),
            surnameTextField.leftAnchor.constraint(equalTo: nameTextField.rightAnchor, constant: 10),
            surnameTextField.rightAnchor.constraint(equalTo: saveButton.leftAnchor, constant: -16),
            locationButton.topAnchor.constraint(equalTo: nameSurnameLabel.bottomAnchor),
            locationButton.leftAnchor.constraint(equalTo: nameSurnameLabel.leftAnchor),
            locationButton.heightAnchor.constraint(equalToConstant: 30),
            locationButton.widthAnchor.constraint(equalToConstant: 30),
            locationLabel.leftAnchor.constraint(equalTo: locationButton.rightAnchor, constant: 12),
            locationLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -8),
            locationLabel.centerYAnchor.constraint(equalTo: locationButton.centerYAnchor),
            searchLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 12),
            searchLabel.leftAnchor.constraint(equalTo: nameSurnameLabel.leftAnchor),
            segmentControl.topAnchor.constraint(equalTo: searchLabel.bottomAnchor, constant: 8),
            segmentControl.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            segmentControl.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
            segmentControl.heightAnchor.constraint(equalToConstant: 28),
            infoLabel.topAnchor.constraint(equalTo: segmentControl.bottomAnchor, constant: 16),
            infoLabel.leftAnchor.constraint(equalTo: segmentControl.leftAnchor),
            addressLabel.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 8),
            addressLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 28),
            addressLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
            emailLabel.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 8),
            emailLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 28),
            emailLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
            lineView.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 16),
            lineView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            lineView.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
            lineView.heightAnchor.constraint(equalToConstant: 2),
            addPetButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            addPetButton.topAnchor.constraint(equalTo: lineView.bottomAnchor, constant: 8),
            addPetButton.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.7),
            addPetButton.heightAnchor.constraint(equalToConstant: 34)
        ])
    }
}
