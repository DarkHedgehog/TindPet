//
//  Registration Service.swift
//  TindPet
//
//  Created by Asya Checkanar on 11.07.2023.
//

import Foundation
import Firebase

protocol RegistrationServiceProtocol {
    func registerNewUser(credentials: Credentials)
    var delegate: RegistrationServiceDelegate? { get set }
}

protocol RegistrationServiceDelegate {
    func didRegisterWith(uid: String)
    func didReceiveEmailAlreadyInUseError()
    func didReceiveUnknownError()
    func didNotReceiveResult()
}

class RegistrationService: RegistrationServiceProtocol {
    private let auth = Auth.auth()
    private let firestore = Firestore.firestore()
    var delegate: RegistrationServiceDelegate?
    func registerNewUser(credentials: Credentials) {
        auth.createUser(withEmail: credentials.email, password: credentials.password) { [weak self] result, error in
            guard let strongSelf = self else {
                return
            }
            if let error = error as? NSError {
                strongSelf.processError(errorID: error.code)
                return
            }
            guard let result = result else {
                strongSelf.delegate?.didNotReceiveResult()
                return
            }
            strongSelf.didReceiveResult(result: result, credentials: credentials)
        }
    }
    // MARK: - Private methods
    private func didReceiveResult(result: AuthDataResult, credentials: Credentials) {
        result.user.sendEmailVerification()
        let uid = result.user.uid
        saveUserData(uid: uid, credentials: credentials)
        delegate?.didRegisterWith(uid: uid)
    }
    private func processError(errorID: Int) {
        switch errorID {
        case AuthErrorCode.emailAlreadyInUse.rawValue:
            delegate?.didReceiveEmailAlreadyInUseError()
        default:
            delegate?.didReceiveUnknownError()
        }
    }
    private func saveUserData(uid: String, credentials: Credentials) {
        let userData: [String: Any] = [
            "email": credentials.email,
            "password": credentials.password,
            "name": credentials.name,
            "surname": credentials.surname,
            "date": Date(),
            "isOwner": false,
            "isVerified": false
        ]
        firestore.collection("users").document(uid).setData(userData)
    }
}
