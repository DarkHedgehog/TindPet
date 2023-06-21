//
//  RegistrationView.swift
//  TindPet
//
//  Created by Aleksandr Derevenskih on 21.06.2023.
//

import UIKit

final class RegistrationView: UIView {
    let textLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configureUI()
    }

    private func configureUI() {
//        self.backgroundColor = .red

        textLabel.text = "Registration"
        textLabel.textAlignment = .center
        textLabel.font = UIFont.systemFont(ofSize: 26.0)
        textLabel.textColor = .yellow
        self.addSubview(self.textLabel)
        self.setupConstraints()
    }

    private func setupConstraints() {
        let safeArea = self.safeAreaLayoutGuide
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: safeArea.topAnchor),
            textLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            textLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            textLabel.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }
}
