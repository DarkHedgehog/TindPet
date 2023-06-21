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

    init(window: UIWindow?) {
        self.window = window
    }

    func start() {
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

        window?.rootViewController = tabsVC
        window?.makeKeyAndVisible()
    }

    private func configureRegistrationController() -> UIViewController {
        let controller = RegistrationViewController()
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
        let controller = ProfileViewController()
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
