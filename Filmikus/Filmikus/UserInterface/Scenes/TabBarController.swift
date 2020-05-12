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
		
		let layerGradient = CAGradientLayer()
		// UIColor(red: 238, green: 135, blue: 85), UIColor(red: 103, green: 56, blue: 162)
		layerGradient.colors = [UIColor(red: 238, green: 135, blue: 85).cgColor, UIColor(red: 103, green: 56, blue: 162).cgColor]
        layerGradient.startPoint = CGPoint(x: 0, y: 0.5)
        layerGradient.endPoint = CGPoint(x: 1, y: 0.5)
        layerGradient.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        self.tabBar.layer.addSublayer(layerGradient)
        
        let mainVC = MainViewController()
        let mainNavVC = UINavigationController(rootViewController: mainVC)
        mainNavVC.tabBarItem = UITabBarItem(
			title: "Главная",
			image: UIImage(systemName: "house"),
			selectedImage: UIImage(systemName: "house.fill")
		)
        
        let filmsVC = FilmsViewController()
        let filmsNavVC = UINavigationController(rootViewController: filmsVC)
        filmsNavVC.tabBarItem = UITabBarItem(
			title: "Фильмы",
			image: UIImage(systemName: "film"),
			selectedImage: UIImage(systemName: "film.fill")
		)

        let serialsVC = UIViewController()
        let serialsNavVC = UINavigationController(rootViewController: serialsVC)
        serialsNavVC.tabBarItem = UITabBarItem(
			title: "Сериалы",
			image: UIImage(systemName: "tv"),
			selectedImage: UIImage(systemName: "tv.fill")
		)

        let videosVC = UIViewController()
        let videosNavVC = UINavigationController(rootViewController: videosVC)
        videosNavVC.tabBarItem = UITabBarItem(
			title: "Видео",
			image: UIImage(systemName: "video"),
			selectedImage: UIImage(systemName: "video.fill")
		)

		let profileVC = UIViewController()
        let profileNavVC = UINavigationController(rootViewController: profileVC)
        profileNavVC.tabBarItem = UITabBarItem(
			title: "Профиль",
			image: UIImage(systemName: "person.crop.square"),
			selectedImage: UIImage(systemName: "person.crop.square.fill")
		)
		
        viewControllers = [mainNavVC, filmsNavVC, serialsNavVC, videosNavVC, profileNavVC]
    }

}
