//
//  Edit Profile Service.swift
//  TindPet
//
//  Created by Asya Checkanar on 23.07.2023.
//

import Foundation
import Firebase

protocol EditServiceProtocol {
    var delegate: EditServiceDelegate? { get set }
}

protocol EditServiceDelegate {
    
}

class EditService: EditServiceProtocol {
    private let auth = Auth.auth()
    private let firestore = Firestore.firestore()
    var delegate: EditServiceDelegate?
    
    func updateCurrentUserData() {
            Firestore.firestore().collection("users").document().updateData()
        }
}
