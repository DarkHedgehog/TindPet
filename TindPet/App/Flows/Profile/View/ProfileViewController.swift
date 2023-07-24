//
//  ProfileView.swift
//  TindPet
//
//  Created by Aleksandr Derevenskih on 27.06.2023.
//

import UIKit

protocol ProfilePresenterProtocol {
    func viewDidLoad()
    func tabLogoutButton()
    func addPetButtonAction()
    func selectedPetImage(index: IndexPath)
    func pickedImage(image: UIImage)
    func deletePet(index: IndexPath)
}

final class ProfileViewController: UIViewController {
    var presenter: ProfilePresenterProtocol?
    private var tapGest: UITapGestureRecognizer?
    private var profileView: ProfileView {
        return self.view as! ProfileView
    }
    private var avatarImage = UIImage(named: "addPhoto1")
    private var myPets: [PetModel] = []
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
        presenter?.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addObserver()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeObserver()
        endEditing()
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
    // MARK: - Functions
    private func addObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyBoardWasShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyBoardWillBeHidden(notification:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }
    private func removeObserver() {
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }
    @objc private func keyBoardWasShow(notification: Notification) {
        if tapGest == nil {
            tapGest = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        }
        guard let tapGest = tapGest,
              let info = notification.userInfo as? NSDictionary,
              let value = info.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as? NSValue
        else { return }
        profileView.addGestureRecognizer(tapGest)
        let kbSize = value.cgRectValue.size
        let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: kbSize.height, right: 0)
        profileView.tableView.contentInset = contentInset
        profileView.tableView.scrollIndicatorInsets = contentInset
    }
    @objc private func keyBoardWillBeHidden(notification: Notification) {
        let contentInset = UIEdgeInsets.zero
        profileView.tableView.contentInset = contentInset
    }
    @objc private func endEditing() {
        profileView.endEditing(true)
    }
}
// MARK: - UITableViewDelegate, UITableViewDataSource
extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return tableView.frame.height * 0.4
        case 1:
            return 320
        default:
            return 120
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2 + myPets.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            guard
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: AvatarCell.identifier,
                    for: indexPath) as? AvatarCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            cell.configure(avatar: avatarImage ?? UIImage())
            return cell
        case 1:
            guard
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: AccountInfoCell.identifier,
                    for: indexPath) as? AccountInfoCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            cell.delegate = self
            return cell
        default:
            guard
                let petCell = tableView.dequeueReusableCell(
                    withIdentifier: PetCell.identifier,
                    for: indexPath) as? PetCell else { return UITableViewCell() }
            petCell.selectionStyle = .none
            petCell.delegate = self
            petCell.configure(model: myPets[indexPath.row - 2])
            return petCell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            presenter?.selectedPetImage(index: indexPath)
        default:
            break
        }
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        switch indexPath.row {
        case (0..<2):
            return false
        default:
            return true
        }
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            presenter?.deletePet(index: indexPath)
        }
    }
}
// MARK: - ProfileViewProtocol
extension ProfileViewController: ProfileViewProtocol {
    func setAvatarImge(avatat: UIImage) {
        avatarImage = avatat
        DispatchQueue.main.async {
            self.profileView.tableView.reloadData()
        }
    }
    func showPets(pets: [PetModel]) {
        self.myPets = pets
        DispatchQueue.main.async {
            self.profileView.tableView.reloadData()
        }
    }
    func showImagePicker() {
        selectImage()
    }
}
// MARK: - AccountInfoCellDelegate, PetCellDelegate
extension ProfileViewController: AccountInfoCellDelegate, PetCellDelegate {
    func addPetButtonAction() {
        presenter?.addPetButtonAction()
    }
    func tapPetPhoto(from cell: UITableViewCell) {
        guard let indexPath = profileView.tableView.indexPath(for: cell) else { return }
        presenter?.selectedPetImage(index: indexPath)
    }
}
// MARK: - UIImagePickerControllerDelegate & UINavigationControllerDelegate
extension ProfileViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func selectImage() {
        let photoImage = UIImage(systemName: "photo.on.rectangle.angled")
        let cameraImage = UIImage(systemName: "camera")
        let alert = UIAlertController(
            title: "Select image",
            message: nil,
            preferredStyle: .actionSheet)
        let actionPhoto = UIAlertAction(title: "Gallery", style: .default) { _ in
            self.chooseImagePicker(source: .photoLibrary)
        }
        actionPhoto.setValue(photoImage, forKey: "image")
        actionPhoto.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
        let actionCamera = UIAlertAction(title: "Camera", style: .default) { _ in
            self.chooseImagePicker(source: .camera)
        }
        actionCamera.setValue(cameraImage, forKey: "image")
        actionCamera.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(actionPhoto)
        alert.addAction(actionCamera)
        alert.addAction(actionCancel)
        present(alert, animated: true, completion: nil)
    }
    func chooseImagePicker(source: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = source
            present(imagePicker, animated: true)
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            presenter?.pickedImage(image: pickedImage)
        }
        dismiss(animated: true)
    }
}
