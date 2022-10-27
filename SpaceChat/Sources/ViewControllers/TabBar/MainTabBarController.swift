//
//  TabBarController.swift
//  SpaceChat
//
//  Created by User on 26.10.2022.
//

import Foundation
import UIKit

class MainTabBarController: UITabBarController {

    private let currentUser: MUser

    init(currentUser: MUser) {
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        tabBar.backgroundColor = .white
        tabBar.tintColor = .tabBarTintColor()
        tabBar.isTranslucent = false
    }

    private func setupTabBar() {
        let usersVC = UsersViewController(currentUser: currentUser)
        let chatListVC = ChatListViewController(currentUser: currentUser)
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
