//
//  AccountHeaderView.swift
//  TindPet
//
//  Created by Артур Кондратьев on 19.07.2023.
//

import UIKit

class AvatarCell: UITableViewCell {
    static let identifier = "AvatarCell"
    // MARK: - Subviews
    lazy var personAvatar: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return image
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
    func configure(avatar: UIImage) {
        personAvatar.image = avatar
    }
    // MARK: - UI
    private func setUI() {
        self.addSubview(personAvatar)
        NSLayoutConstraint.activate([
            personAvatar.topAnchor.constraint(equalTo: topAnchor),
            personAvatar.leftAnchor.constraint(equalTo: leftAnchor),
            personAvatar.rightAnchor.constraint(equalTo: rightAnchor),
            personAvatar.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
