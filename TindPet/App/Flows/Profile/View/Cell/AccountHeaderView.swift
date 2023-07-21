//
//  AccountHeaderView.swift
//  TindPet
//
//  Created by Артур Кондратьев on 19.07.2023.
//

import UIKit

protocol AccountHeaderViewProtocol: AnyObject {
    func didTabAvatar(sender: UITapGestureRecognizer)
}

class AccountHeaderView: UITableViewHeaderFooterView {
    static let identifier = "AccountHeaderView"
    weak var delegate: AccountHeaderViewProtocol?
    // MARK: - Subviews
    lazy var personIcon: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "person")
        image.contentMode = .scaleToFill
        image.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapOnAvatar(sender:)))
        image.addGestureRecognizer(tapGesture)
        image.isUserInteractionEnabled = true
        return image
    }()
    // MARK: - Init
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setUI()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUI()
    }
    // MARK: - Actions
    @objc func tapOnAvatar(sender: UITapGestureRecognizer) {
        delegate?.didTabAvatar(sender: sender)
    }
    // MARK: - UI
    private func setUI() {
        self.addSubview(personIcon)
        NSLayoutConstraint.activate([
            personIcon.topAnchor.constraint(equalTo: topAnchor),
            personIcon.leftAnchor.constraint(equalTo: leftAnchor),
            personIcon.rightAnchor.constraint(equalTo: rightAnchor),
            personIcon.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
