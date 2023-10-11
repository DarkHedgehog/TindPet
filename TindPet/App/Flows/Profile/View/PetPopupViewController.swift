//
//  PetPopupViewController.swift
//  TindPet
//
//  Created by Asya Checkanar on 10.10.2023.
//

import UIKit

protocol PetPopupPresenterProtocol {
    
}

class PetPopupViewController: UIViewController {
    private var petPopupView: PetPopupView {
        return self.view as! PetPopupView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    //MARK: - Private Methods
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
        
    }
    @objc private func keyBoardWillBeHidden(notification: Notification) {
        
    }
    @objc private func endEditing() {
        petPopupView.endEditing(true)
    }

}
