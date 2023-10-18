//
//  PetPopupViewController.swift
//  TindPet
//
//  Created by Asya Checkanar on 10.10.2023.
//

import UIKit

protocol PetPopupPresenterProtocol {
    func pickedImage(image: UIImage)
    func selectedPetImage()
    func savePetButtonAction(petInfo: PetInfo?)
}

class PetPopupViewController: UIViewController {
    var presenter: PetPopupPresenterProtocol?
    private var tapGest: UITapGestureRecognizer?
    private var petPopupView: PetPopupView {
        return self.view as! PetPopupView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        petPopupView.delegate = self
        petPopupView.configureView()
    }
    override func loadView() {
        super.loadView()
        self.view = PetPopupView()
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

    // MARK: - Private Methods
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
        guard let userInfo = notification.userInfo else { return }
        guard let screen = notification.object as? UIScreen,
              let keyboardFrameEnd = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let fromCoordinateSpace = screen.coordinateSpace
        let toCoordinateSpace: UICoordinateSpace = view
        let convertedKeyboardFrameEnd = fromCoordinateSpace.convert(keyboardFrameEnd, to: toCoordinateSpace)
    }
    @objc private func keyBoardWillBeHidden(notification: Notification) {
        
    }
    @objc private func endEditing() {
        petPopupView.endEditing(true)
    }
}
extension PetPopupViewController: PetPopupViewProtocol {
    func dismissPetPopup() {
        dismiss(animated: true)
    }
    
    func showImagePicker() {
        selectImage()
    }
    func showInfo(title: String, message: String) {
        showAlert(title: title, message: message)
    }
    func showChosenImage(image: UIImage) {
        petPopupView.petPhotoImageView.image = image
    }
}

// MARK: - UIImagePickerControllerDelegate & UINavigationControllerDelegate
extension PetPopupViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
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
// MARK: - View Delegate
extension PetPopupViewController: PetPopupViewDelegate {
    func tapPetPhoto() {
        presenter?.selectedPetImage()
    }
    func savePetButtonAction() {
        var petInfo = PetInfo()
        guard let name = petPopupView.petNameTextField.text,
              let age = Int(petPopupView.petAgeTextField.text ?? "0"),
              let image = petPopupView.petPhotoImageView.image else { return }
              let species = petPopupView.segmentControl.selectedSegmentIndex
        petInfo.name = name
        petInfo.age = age
        petInfo.species = species
        petInfo.image = image
        presenter?.savePetButtonAction(petInfo: petInfo)
    }
    func discardPetButtonAction() {
        dismiss(animated: true)
    }
}
