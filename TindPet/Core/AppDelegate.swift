//
//  AppDelegate.swift
//  TindPet
//
//  Created by Aleksandr Derevenskih on 21.06.2023.
//

import UIKit
import FirebaseCore

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var appCoordinator: AppCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        FirebaseApp.configure()

        let navigatinVC = UINavigationController.init()
        appCoordinator = AppCoordinator(navigetinController: navigatinVC)
        appCoordinator?.start()
        window?.rootViewController = navigatinVC
        window?.makeKeyAndVisible()
        return true
    }
}
