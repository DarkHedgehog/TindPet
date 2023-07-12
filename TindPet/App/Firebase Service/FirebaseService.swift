//
//  FirebaseService.swift
//  TindPet
//
//  Created by Asya Checkanar on 08.07.2023.
//

import Foundation
import Firebase

protocol TindPetNetworkServiceProtocol {
    func registerNewUser(name: String, surname: String, email: String, password: String, completion: @escaping (Bool) -> Void)
    func saveUserData(uid: String, email: String, password: String, name: String, surname: String)
    func signIn(email: String, password: String, completion: @escaping (Bool) -> Void)
    func getCurrentUserID() -> String
    func getCurrentUserInfo(completion: @escaping ([String: Any]) -> Void)
}

class FirebaseService: TindPetNetworkServiceProtocol {
    //функция зарегистрироваться
    func registerNewUser(name: String, surname: String, email: String, password: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] res, err in
            guard let strongSelf = self else {
                return
            }
            if err == nil {
                if let res = res {
                    res.user.sendEmailVerification()
                    strongSelf.saveUserData(uid: res.user.uid, email: email, password: password, name: name, surname: surname)
                    completion(true)
                }
            } else {
                if let err = err as? NSError {
                    switch err.code {
                    case AuthErrorCode.emailAlreadyInUse.rawValue:
                        //вставить
                        completion(false)
                    default:
                        completion(true)
                    }
                }
            }
        }
    }
    //функция сохранить данные пользователя
    func saveUserData(uid: String, email: String, password: String, name: String, surname: String) {
        let userData: [String: Any] = [
            "email": email,
            "password": password,
            "name": name,
            "surname": surname,
            "date": Date(),
            "isOwner": false,
            "isVerified": false
        ]
        Firestore.firestore().collection("users").document(uid).setData(userData)
    }
    //функция войти
    func signIn(email: String, password: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { res, err in
            if err == nil {
                if let res = res {
                    if res.user.isEmailVerified {
                        completion(true)
                    } else {
                        //вставить alert
                        completion(false)
                    }
                }
            } else {
                if let err = err as? NSError {
                    switch err.code {
                    case AuthErrorCode.wrongPassword.rawValue:
                        //вставить alert
                        completion(false)
                    default:
                        completion(true)
                    }
                }
            }
        }
    }
    // получить данные текущего пользователя
    func getCurrentUserID() -> String {
        guard let uid = Auth.auth().currentUser?.uid else {
            return ""
        }
        return uid
    }
    func getCurrentUserInfo(completion: @escaping ([String: Any]) -> Void) {
        let uid = getCurrentUserID()
        var userInfo: [String: Any] = [:]
        Firestore.firestore().collection("users").document(uid).getDocument { snapshot, error in
            if error == nil {
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
            } else {
                if let error = error as? NSError {
                    // TODO: прописать работу с ошибками
                    print(error)
                }
            }
        }
    }
//    func updateCurrentUserData() {
//        Firestore.firestore().collection("users").document(getCurrentUserID()).updateData()
//    }
    //создать окно с предупреждением об ошибке
//    func showAlert(title: String, message: String) {
//        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "OK",
//                                      style: .default,
//                                     handler: {_ in
//
//        }))
////        present(alert, animated: true)
//    }
}
