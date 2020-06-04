//
//  MainViewController.swift
//  Filmikus
//
//  Created by Андрей Козлов on 07.05.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import UIKit
import SnapKit

class MainViewController: UIViewController {
	
	private let mainService: MainServiceType
	
	private lazy var categoriesViewController: CategoriesViewController = {
		let viewController = CategoriesViewController()
		viewController.delegate = self
		return viewController
	}()
	private lazy var searchController = SearchController(searchResultsController: nil)
	
	init(mainService: MainServiceType = MainService()) {
		self.mainService = mainService
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func loadView() {
		view = UIView()
		view.backgroundColor = .appDarkBlue
		addChild(categoriesViewController)
		view.addSubview(categoriesViewController.view)
		categoriesViewController.didMove(toParent: self)
		
		categoriesViewController.view.snp.makeConstraints {
			$0.edges.equalToSuperview()
		}
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		
		title = "Главная"

		navigationItem.searchController = searchController
		
		loadData()
    }
	
	private func loadData() {
		mainService.getSlider { [weak self] result in
			guard let self = self else { return }
			guard let sliders = try? result.get() else { return }
			self.categoriesViewController.update(sliders: sliders)
		}
		
		var categories: [Category] = [
			Category(title: "Популярное"),
			Category(title: "Рекомендуем"),
			Category(title: "Сериалы")
		]
		let dispatchGroup = DispatchGroup()
		
		dispatchGroup.enter()
		mainService.getPopular { result in
			dispatchGroup.leave()
			guard let movies = try? result.get() else { return }
			categories[0].movies = movies
		}
		
		dispatchGroup.enter()
		mainService.getRecommendations { result in
			dispatchGroup.leave()
			guard let movies = try? result.get() else { return }
			categories[1].movies = movies
		}
		
		dispatchGroup.enter()
		mainService.getSeries { result in
			dispatchGroup.leave()
			guard let movies = try? result.get() else { return }
			categories[2].movies = movies
		}
		
		dispatchGroup.notify(queue: .main) { [weak self] in
			guard let self = self else { return }
			self.categoriesViewController.update(categories: categories)
		}
	}

}

// MARK: - CategoriesViewControllerDelegate

extension MainViewController: CategoriesViewControllerDelegate {
	
	func categoriesViewController(_ viewController: CategoriesViewController, didSelectCategory category: Category) {
		switch category.title {
		case "Популярное":
			tabBarController?.selectedIndex = 1
		case "Рекомендуем":
			tabBarController?.selectedIndex = 1
		case "Сериалы":
			tabBarController?.selectedIndex = 2
		case "Развлекательное видео":
			tabBarController?.selectedIndex = 3
		default:
			break
		}
	}
	
	func categoriesViewController(_ viewController: CategoriesViewController, didSelectMovie movie: MovieModel) {
		let detailMovieVC = DetailMovieViewController(movie: movie)
		navigationController?.pushViewController(detailMovieVC, animated: true)
	}
}
