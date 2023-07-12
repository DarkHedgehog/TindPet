//
//  AppStartManager.swift
//  TindPet
//
//  Created by Aleksandr Derevenskih on 21.06.2023.
//

import Foundation

import UIKit

final class AppStartManager {
    var window: UIWindow?
    var userDefaults = UserDefaults.standard

    init(window: UIWindow?) {
        self.window = window
    }

    func start() {
        let isLoggedIn = userDefaults.object(forKey: "isLoggedIn") as? Bool ?? false
        let registrationVC = configureRegistrationController()
        let swipesVC = configureSwipesController()
        let matchesVC = configureMatchesController()
        let profileVC = configureProfileController()

        let tabsVC = UITabBarController()
        tabsVC.setViewControllers(
            [
                registrationVC,
                swipesVC,
                matchesVC,
                profileVC
            ],
            animated: false)

        let logVC = LoginViewBuilder.build()
        let navVC = UINavigationController(rootViewController: logVC)
        if isLoggedIn {
            //открываем основное приложение
            window?.rootViewController = tabsVC
        } else {
            //открываем экран аутентификации
            window?.rootViewController = navVC
        }
//        window?.rootViewController = navVC //tabsVC
        window?.makeKeyAndVisible()
    }

    private func configureRegistrationController() -> UIViewController {
        let controller = RegistrationViewBuilder.build()
        let navVC = UINavigationController()

        navVC.navigationBar.barTintColor = UIColor.blue
        navVC.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navVC.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navVC.tabBarItem.image = UIImage(systemName: "exclamationmark.triangle.fill")
        navVC.viewControllers = [controller]
        navVC.title = "Login"
        return navVC
    }

    private func configureSwipesController() -> UIViewController {
        let controller = SwipesViewController()
        let navVC = UINavigationController()

        navVC.navigationBar.barTintColor = UIColor.blue
        navVC.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navVC.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navVC.tabBarItem.image = UIImage(systemName: "tray.circle")
        navVC.viewControllers = [controller]
        navVC.title = "Swipes"
        return navVC
    }

    private func configureMatchesController() -> UIViewController {
        let controller = MatchesViewController()
        let navVC = UINavigationController()

        navVC.navigationBar.barTintColor = UIColor.blue
        navVC.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navVC.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navVC.tabBarItem.image = UIImage(systemName: "paperclip.circle")
        navVC.viewControllers = [controller]
        navVC.title = "Matches"
        return navVC
    }

    private func configureProfileController() -> UIViewController {
        let controller = ProfileViewBuilder.build()
        let navVC = UINavigationController()

        navVC.navigationBar.barTintColor = UIColor.blue
        navVC.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navVC.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navVC.viewControllers = [controller]
        navVC.tabBarItem.image = UIImage(systemName: "exclamationmark.triangle.fill")
        navVC.title = "Profile"
        return navVC
    }
}
