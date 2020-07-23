//
//  TabBarController.swift
//  Filmikus
//
//  Created by Андрей Козлов on 07.05.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
		
	private let userFacade: UserFacadeType = UserFacade()
	
	private lazy var mainViewController: MainViewController = {
		let viewController = MainViewController()
		viewController.delegate = self
		return viewController
	}()
	private lazy var filmsViewController = FilmsViewController()
	private lazy var serialsViewController = SerialsViewController()
	private lazy var videosViewController = VideosViewController()
	private lazy var profileViewController = ProfileViewController()

    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.tintColor = .white
		tabBar.barTintColor = .appNightBlue
		tabBar.unselectedItemTintColor = .white
        
        let mainNavVC = NavigationController(rootViewController: mainViewController)
		mainNavVC.apply(gradientStyle: .orangePurple)
        mainNavVC.tabBarItem = UITabBarItem(
			title: "Главная",
			image: UIImage(systemName: "house"),
			selectedImage: UIImage(systemName: "house.fill")
		)
        
        let filmsNavVC = NavigationController(rootViewController: filmsViewController)
		filmsNavVC.apply(gradientStyle: .bluePurple)
        filmsNavVC.tabBarItem = UITabBarItem(
			title: "Фильмы",
			image: UIImage(systemName: "film"),
			selectedImage: UIImage(systemName: "film.fill")
		)

        let serialsNavVC = NavigationController(rootViewController: serialsViewController)
		serialsNavVC.apply(gradientStyle: .orangePurple)
        serialsNavVC.tabBarItem = UITabBarItem(
			title: "Сериалы",
			image: UIImage(systemName: "tv"),
			selectedImage: UIImage(systemName: "tv.fill")
		)
        let videosNavVC = NavigationController(rootViewController: videosViewController)
		videosNavVC.apply(gradientStyle: .orangePurple)
        videosNavVC.tabBarItem = UITabBarItem(
			title: "Видео",
			image: UIImage(systemName: "video"),
			selectedImage: UIImage(systemName: "video.fill")
		)

        let profileNavVC = NavigationController(rootViewController: profileViewController)
		profileNavVC.apply(gradientStyle: .bluePurple)
        profileNavVC.tabBarItem = UITabBarItem(
			title: "Профиль",
			image: UIImage(systemName: "person.crop.square"),
			selectedImage: UIImage(systemName: "person.crop.square.fill")
		)
		
        viewControllers = [mainNavVC, filmsNavVC, serialsNavVC, videosNavVC, profileNavVC]
    }
}

// MARK: - MainViewControllerDelegate

extension TabBarController: MainViewControllerDelegate {
	
	func mainViewController(_ viewController: MainViewController, didSelectCategoryType type: CategoryType) {
		switch type {
		case .popular:
			filmsViewController.applyFilter(order: .popular)
			selectedIndex = 1
		case .recommendations:
			filmsViewController.applyFilter(order: .new)
			selectedIndex = 1
		case .series:
			selectedIndex = 2
		case .funShow:
			selectedIndex = 3
		}
	}
}
