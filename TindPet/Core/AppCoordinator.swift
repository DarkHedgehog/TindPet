//
//  AppStartManager.swift
//  TindPet
//
//  Created by Aleksandr Derevenskih on 21.06.2023.
//

import UIKit

protocol AppCoordinatorProtocol {
    func start()
    func goToLoginVC(didTapLogout: Bool)
    func goToRegistrationVC()
    func goToMainScene()
    func goToPetDetail(_ pet: PetInfo)
    func goToBack()
}

final class AppCoordinator: AppCoordinatorProtocol {
    var navigatinController: UINavigationController

    init(navigetinController: UINavigationController) {
        self.navigatinController = navigetinController
    }

    func start() {
        if UserDefaults.standard.bool(forKey: Key.isLogin) {
            goToMainScene()
        } else {
            goToLoginVC()
        }
    }

    func goToLoginVC(didTapLogout: Bool = false) {
        let logVC = LoginViewBuilder.build(coordinator: self)
        if didTapLogout {
//            logVC.modalPresentationStyle = .fullScreen
//            logVC.modalTransitionStyle = .flipHorizontal
//            navigatinController.present(logVC, animated: true)
            navigatinController.pushViewController(logVC, animated: true)
        } else {
            navigatinController.pushViewController(logVC, animated: true)
        }
    }

    func goToRegistrationVC() {
        let regVC = RegistrationViewBuilder.build(coordinator: self)
        navigatinController.pushViewController(regVC, animated: true)
    }

    func goToPetDetail(_ pet: PetInfo) {
        let controller = PetDetailViewBuilder.build(petId: pet.petID, coordinator: self)
        navigatinController.pushViewController(controller, animated: true)
    }

    func goToMainScene() {
        let swipesVC = configureSwipesController()
        let matchesVC = configureMatchesController()
        let profileVC = configureProfileController()
        let tabsVC = UITabBarController()
        tabsVC.tabBar.barTintColor = .systemGray5
        tabsVC.setViewControllers([swipesVC, matchesVC, profileVC], animated: false)
        navigatinController.pushViewController(tabsVC, animated: true)
        navigatinController.navigationBar.isHidden = true
    }

    func goToBack() {
        navigatinController.popViewController(animated: true)
    }

    private func configureSwipesController() -> UIViewController {
        let controller = SwipesViewBuilder.build()
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
        let controller = MatchesViewBuilder.build(coordinator: self)
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
        let controller = ProfileViewBuilder.build(coordinator: self)
        let navVC = UINavigationController()
        navVC.navigationBar.barTintColor = UIColor.systemBackground
        navVC.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navVC.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        navVC.viewControllers = [controller]
        navVC.tabBarItem.image = UIImage(systemName: "person")
        navVC.title = "Profile"
        return navVC
    }
}
