//
//  ProfileView.swift
//  TindPet
//
//  Created by Aleksandr Derevenskih on 27.06.2023.
//

import UIKit

protocol ProfilePresenterProtocol {
    func tabLogoutButton()
}

final class ProfileViewController: UIViewController {
    var presenter: ProfilePresenterProtocol?
    private var profileView: ProfileView {
        return self.view as! ProfileView
    }
    // MARK: - LifeCycle
    override func loadView() {
        super.loadView()
        self.view = ProfileView()
        profileView.tableView.dataSource = self
        profileView.tableView.delegate = self
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
    }
    // MARK: - Configure
    private func configureNavBar() {
        let logoutButton: UIButton = {
            let button = UIButton(type: .system)
            button.addTarget(self, action: #selector(logoutButtonAction), for: .touchUpInside)
            button.setTitle("Logout", for: .normal)
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
            button.tintColor = .topGradientColor
            return button
        }()
        self.title = "Profile"
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: logoutButton)
    }
    @objc func logoutButtonAction() {
        presenter?.tabLogoutButton()
    }
}
// MARK: - UITableViewDelegate, UITableViewDataSource
extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return tableView.frame.width
        default:
            return 0
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 280
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 2
        default:
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: AccountInfoCell.identifier,
                for: indexPath) as? AccountInfoCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard
            let header = tableView.dequeueReusableHeaderFooterView(
                withIdentifier: AccountHeaderView.identifier) as? AccountHeaderView else { return UITableViewHeaderFooterView() }
      //  header.delegate = self
        return header
    }
}
// MARK: - ProfileViewProtocol
extension ProfileViewController: ProfileViewProtocol {
}
