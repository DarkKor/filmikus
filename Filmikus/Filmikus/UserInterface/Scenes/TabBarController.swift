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

        tabBar.tintColor = .white
		tabBar.barTintColor = .appNightBlue
		tabBar.unselectedItemTintColor = .white
        
        let mainVC = MainViewController()
        let mainNavVC = NavigationController(rootViewController: mainVC)
        mainNavVC.tabBarItem = UITabBarItem(
			title: "Главная",
			image: UIImage(systemName: "house"),
			selectedImage: UIImage(systemName: "house.fill")
		)
        
        let filmsVC = FilmsViewController()
        let filmsNavVC = NavigationController(rootViewController: filmsVC)
        filmsNavVC.tabBarItem = UITabBarItem(
			title: "Фильмы",
			image: UIImage(systemName: "film"),
			selectedImage: UIImage(systemName: "film.fill")
		)

        let serialsVC = SerialsViewController()
        let serialsNavVC = NavigationController(rootViewController: serialsVC)
        serialsNavVC.tabBarItem = UITabBarItem(
			title: "Сериалы",
			image: UIImage(systemName: "tv"),
			selectedImage: UIImage(systemName: "tv.fill")
		)

        let videosVC = VideosViewController()
        let videosNavVC = NavigationController(rootViewController: videosVC)
        videosNavVC.tabBarItem = UITabBarItem(
			title: "Видео",
			image: UIImage(systemName: "video"),
			selectedImage: UIImage(systemName: "video.fill")
		)

		let profileVC = ProfileViewController()
        let profileNavVC = NavigationController(rootViewController: profileVC)
        profileNavVC.tabBarItem = UITabBarItem(
			title: "Профиль",
			image: UIImage(systemName: "person.crop.square"),
			selectedImage: UIImage(systemName: "person.crop.square.fill")
		)
		
        viewControllers = [mainNavVC, filmsNavVC, serialsNavVC, videosNavVC, profileNavVC]
    }

}
