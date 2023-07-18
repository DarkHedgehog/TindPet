//
//  UIViewController Extension.swift
//  TindPet
//
//  Created by Asya Checkanar on 10.07.2023.
//

import UIKit

extension UIViewController {
    func showAlert(title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        
        alertVC.addAction(okAction)
        present(alertVC, animated: true)        
    }
}
