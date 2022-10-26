//
//  TabBarController.swift
//  SpaceChat
//
//  Created by User on 26.10.2022.
//

import Foundation
import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        tabBar.backgroundColor = .white
        tabBar.tintColor = .tabBarTintColor()
        tabBar.isTranslucent = false
    }

    private func setupTabBar() {
        let usersVC = UsersViewController()
        let chatListVC = ChatListViewController()
        let boldConfig = UIImage.SymbolConfiguration(weight: .medium)
        guard let usersVCImage = UIImage(systemName: "person.2", withConfiguration: boldConfig), let chatListVCImage = UIImage(systemName: "bubble.left.and.bubble.right", withConfiguration: boldConfig) else { return }
        viewControllers = [
            generateNavigationController(rootVC: usersVC,
                                         title: "Users",
                                         image: usersVCImage),
            generateNavigationController(rootVC: chatListVC,
                                         title: "Chats",
                                         image: chatListVCImage)
        ]
    }

    private func generateNavigationController(rootVC: UIViewController, title: String, image: UIImage) -> UIViewController {
        let navigationVC = UINavigationController(rootViewController: rootVC)
        navigationController?.navigationBar.isTranslucent = true
        navigationVC.tabBarItem.title = title
        navigationVC.tabBarItem.image = image
        return navigationVC
    }

}
