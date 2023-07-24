//
//  AccountInfoCell.swift
//  TindPet
//
//  Created by Артур Кондратьев on 19.07.2023.
//

import UIKit

protocol AccountInfoCellDelegate: AnyObject {
    func addPetButtonAction()
}

class AccountInfoCell: UITableViewCell {
    static let identifier = "AccountInfoCell"
    weak var delegate: AccountInfoCellDelegate?
    // MARK: - Subviews
    lazy var nameSurnameLable: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 24)
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .left
        label.textColor = .black
        label.text = "Карина Осипова"
        return label
    }()
    lazy var locationButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "location"), for: .normal)
        button.tintColor = .systemGreen
        return button
    }()
    lazy var locationLable: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18)
        label.textColor = .systemGray
        label.numberOfLines = 0
        label.text = "Челябинск, Россия"
        return label
    }()
    lazy var searchLable: UILabel = {
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
    lazy var infoLable: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = .black
        label.text = "Контакты"
        return label
    }()
    lazy var addressLable: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 14)
        label.textColor = .black
        label.numberOfLines = 0
        label.text = "Адрес: Россия, Челябинск, Загорская, 60"
        return label
    }()
    lazy var emailLable: UILabel = {
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
    func configure() {
    }
    @objc private func tapAddButton() {
        delegate?.addPetButtonAction()
    }
    // MARK: - UI
    private func setUI() {
        backgroundColor = .systemBackground
        contentView.addSubview(nameSurnameLable)
        contentView.addSubview(locationButton)
        contentView.addSubview(locationLable)
        contentView.addSubview(searchLable)
        contentView.addSubview(segmentControl)
        contentView.addSubview(infoLable)
        contentView.addSubview(addressLable)
        contentView.addSubview(emailLable)
        contentView.addSubview(lineView)
        contentView.addSubview(addPetButton)
        NSLayoutConstraint.activate([
            nameSurnameLable.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            nameSurnameLable.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            nameSurnameLable.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
            locationButton.topAnchor.constraint(equalTo: nameSurnameLable.bottomAnchor, constant: 16),
            locationButton.leftAnchor.constraint(equalTo: nameSurnameLable.leftAnchor),
            locationButton.heightAnchor.constraint(equalToConstant: 30),
            locationButton.widthAnchor.constraint(equalToConstant: 30),
            locationLable.leftAnchor.constraint(equalTo: locationButton.rightAnchor, constant: 12),
            locationLable.rightAnchor.constraint(equalTo: rightAnchor, constant: -8),
            locationLable.centerYAnchor.constraint(equalTo: locationButton.centerYAnchor),
            searchLable.topAnchor.constraint(equalTo: locationLable.bottomAnchor, constant: 12),
            searchLable.leftAnchor.constraint(equalTo: nameSurnameLable.leftAnchor),
            segmentControl.topAnchor.constraint(equalTo: searchLable.bottomAnchor, constant: 8),
            segmentControl.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            segmentControl.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
            segmentControl.heightAnchor.constraint(equalToConstant: 28),
            infoLable.topAnchor.constraint(equalTo: segmentControl.bottomAnchor, constant: 16),
            infoLable.leftAnchor.constraint(equalTo: segmentControl.leftAnchor),
            addressLable.topAnchor.constraint(equalTo: infoLable.bottomAnchor, constant: 8),
            addressLable.leftAnchor.constraint(equalTo: leftAnchor, constant: 28),
            addressLable.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
            emailLable.topAnchor.constraint(equalTo: addressLable.bottomAnchor, constant: 8),
            emailLable.leftAnchor.constraint(equalTo: leftAnchor, constant: 28),
            emailLable.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
            lineView.topAnchor.constraint(equalTo: emailLable.bottomAnchor, constant: 16),
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
