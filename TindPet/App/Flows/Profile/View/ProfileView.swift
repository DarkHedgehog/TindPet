//
//  ProfileView.swift
//  TindPet
//
//  Created by Артур Кондратьев on 19.07.2023.
//

import UIKit

class ProfileView: UIView {
    // MARK: - Subviews
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.backgroundColor = .systemBackground
        tableView.separatorInset.left = 0
        tableView.separatorInset.right = 0
        tableView.separatorColor = .clear
        tableView.register(AvatarCell.self, forCellReuseIdentifier: AvatarCell.identifier)
        tableView.register(AccountInfoCell.self, forCellReuseIdentifier: AccountInfoCell.identifier)
        tableView.register(PetCell.self, forCellReuseIdentifier: PetCell.identifier)
        return tableView
    }()
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUI()
    }
    // MARK: - UI
    private func setUI() {
        backgroundColor = .systemBackground
        self.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leftAnchor.constraint(equalTo: leftAnchor),
            tableView.rightAnchor.constraint(equalTo: rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
