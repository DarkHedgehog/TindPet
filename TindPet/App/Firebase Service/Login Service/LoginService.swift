//
//  LoginService.swift
//  TindPet
//
//  Created by Asya Checkanar on 18.07.2023.
//

import Foundation
import Firebase

protocol LoginServiceProtocol {
    func signIn(email: String, password: String)
    var delegate: LoginServiceDelegate? { get set }
}

protocol LoginServiceDelegate {
    func didSignInWith(uid: String)
    func didReceiveUnverifiedEmail()
    func didReceiveWrongPasswordError()
    func didReceiveUnknownError()
    func didNotReceiveResult()
}

class LoginService: LoginServiceProtocol {
    private let auth = Auth.auth()
    private let firestore = Firestore.firestore()
    var delegate: LoginServiceDelegate?
    func signIn(email: String, password: String) {
        auth.signIn(withEmail: email, password: password) { [weak self] result, error in
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
            guard result.user.isEmailVerified else {
                strongSelf.delegate?.didReceiveUnverifiedEmail()
                return
            }
            strongSelf.didReceiveResult(result: result)
        }
    }
    private func didReceiveResult(result: AuthDataResult) {
        let uid = result.user.uid
        delegate?.didSignInWith(uid: uid)
        UserDefaults.standard.set(true, forKey: "isLoggedIn")
    }
    private func processError(errorID: Int) {
        switch errorID {
        case AuthErrorCode.emailAlreadyInUse.rawValue:
            delegate?.didReceiveWrongPasswordError()
        default:
            delegate?.didReceiveUnknownError()
        }
    }
    func getCurrentUserInfo(completion: @escaping ([String: Any]) -> Void) {
        guard let uid = auth.currentUser?.uid else {
            print("not logged in")
            return
        }
        var userInfo: [String: Any] = [:]
        firestore.collection("users").document(uid).getDocument { [weak self] snapshot, error in
            guard let strongSelf = self else {
                return
            }
            if let error = error as? NSError {
                strongSelf.processError(errorID: error.code)
                return
            }
                if let dic = snapshot?.data(),
                   let email = dic["email"] as? String,
                   let name = dic["name"] as? String,
                   let surname = dic["surname"] as? String,
                   let isOwner = dic["isOwner"] as? Bool {
                    userInfo["email"] = email
                    userInfo["name"] = name
                    userInfo["surname"] = surname
                    userInfo["isOwner"] = isOwner
                }
                completion(userInfo)
        }
    }
    func signOut() {
        
    }
}
