//
//  Registration Service.swift
//  TindPet
//
//  Created by Asya Checkanar on 19.07.2023.
//

import Foundation
import Firebase
import FirebaseStorage

protocol RegistrationServiceProtocol {
    func registerNewUser(credentials: Credentials, completion: @escaping (Bool) -> Void)
    var delegate: RegistrationServiceDelegate? { get set }
}

protocol RegistrationServiceDelegate {
    func didRegisterWith(uid: String)
    func didReceiveEmailAlreadyInUseError()
    func didReceiveInvalidEmailError()
    func didReceiveUserNotFoundError()
    func didReceiveObjectNotFoundError()
    func didReceiveCancelledError()
    func didReceiveDocumentAlreadyExistsError()
    func didReceiveDataLossError()
    func didReceiveUnavailableError()
    func didReceiveUnknownError()
    func didNotReceiveResult()
}

class RegistrationService: RegistrationServiceProtocol {
    private let auth = Auth.auth()
    private let firestore = Firestore.firestore()
    var delegate: RegistrationServiceDelegate?
    func registerNewUser(credentials: Credentials, completion: @escaping (Bool) -> Void) {
        auth.createUser(withEmail: credentials.email, password: credentials.password) { [weak self] result, error in
            guard let strongSelf = self else {
                return
            }
            if let error = error as? NSError {
                strongSelf.processError(errorID: error.code)
                completion(false)
                return
            }
            guard let result = result else {
                strongSelf.delegate?.didNotReceiveResult()
                completion(false)
                return
            }
            strongSelf.didReceiveResult(result: result, credentials: credentials)
            completion(true)
        }
    }
    // MARK: - Private methods
    private func didReceiveResult(result: AuthDataResult, credentials: Credentials) {
        result.user.sendEmailVerification { error in
            if let error = error as? NSError {
                self.processError(errorID: error.code)
            }
        }
        let uid = result.user.uid
        saveUserData(uid: uid, credentials: credentials)
        delegate?.didRegisterWith(uid: uid)
    }
    private func processError(errorID: Int) {
        switch errorID {
        case AuthErrorCode.emailAlreadyInUse.rawValue:
            delegate?.didReceiveEmailAlreadyInUseError()
        case AuthErrorCode.invalidEmail.rawValue:
            delegate?.didReceiveInvalidEmailError()
        case AuthErrorCode.userNotFound.rawValue:
            delegate?.didReceiveUserNotFoundError()
        case FirestoreErrorCode.notFound.rawValue:
            delegate?.didReceiveObjectNotFoundError()
        case FirestoreErrorCode.cancelled.rawValue:
            delegate?.didReceiveCancelledError()
        case FirestoreErrorCode.alreadyExists.rawValue:
            delegate?.didReceiveDocumentAlreadyExistsError()
        case FirestoreErrorCode.dataLoss.rawValue:
            delegate?.didReceiveDataLossError()
        case FirestoreErrorCode.unavailable.rawValue:
            delegate?.didReceiveUnavailableError()
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
            "isOwner": credentials.isOwner,
            "isVerified": false
        ]
        firestore.collection("users").document(uid).setData(userData)
    }
}
