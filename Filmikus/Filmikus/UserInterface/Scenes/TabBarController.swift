//
//  TabBarController.swift
//  Filmikus
//
//  Created by Андрей Козлов on 07.05.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
	
	
    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.tintColor = .systemRed
        
        let mainVC = UIViewController()
        let mainNavVC = UINavigationController(rootViewController: mainVC)
        mainNavVC.tabBarItem = UITabBarItem(tabBarSystemItem: .contacts, tag: 0)
        
        let filmsVC = UIViewController()
        let filmsNavVC = UINavigationController(rootViewController: filmsVC)
        filmsNavVC.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 1)

        let serialsVC = UIViewController()
        let serialsNavVC = UINavigationController(rootViewController: serialsVC)
        serialsNavVC.tabBarItem = UITabBarItem(tabBarSystemItem: .topRated, tag: 2)

        let videosVC = UIViewController()
        let videosNavVC = UINavigationController(rootViewController: videosVC)
        videosNavVC.tabBarItem = UITabBarItem(tabBarSystemItem: .more, tag: 3)

		let profileVC = UIViewController()
        let profileNavVC = UINavigationController(rootViewController: profileVC)
        profileNavVC.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 4)
		
        viewControllers = [mainNavVC, filmsNavVC, serialsNavVC, videosNavVC, profileNavVC]
    }

}
