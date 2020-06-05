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
	private let videoService: VideosServiceType
	
	private lazy var categoriesViewController: CategoriesViewController = {
		let viewController = CategoriesViewController()
		viewController.delegate = self
		return viewController
	}()
	private lazy var searchController: SearchController = {
		let searchController = SearchController(searchResultsController: searchResultsController)
		searchController.searchResultsUpdater = self
		return searchController
	}()
	private lazy var searchResultsController: MoviesCollectionViewController = {
		let viewController = MoviesCollectionViewController()
		viewController.delegate = self
		return viewController
	}()
	
	private lazy var searchButton: UIButton = {
		let button = UIButton()
		button.tintColor = .white
		button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
		button.addTarget(self, action: #selector(onSearchButtonTap), for: .touchUpInside)
		return button
	}()

	init(
		mainService: MainServiceType = MainService(),
		videoService: VideosServiceType = VideosService()
	) {
		self.mainService = mainService
		self.videoService = videoService
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

		definesPresentationContext = true
		navigationItem.rightBarButtonItem = UIBarButtonItem(customView: searchButton)
		loadData()
    }
	
	private func loadData() {
		mainService.getSlider { [weak self] result in
			guard let self = self else { return }
			guard let sliders = try? result.get() else { return }
			self.categoriesViewController.update(sliders: sliders)
		}
		
		var categories: [Category] = [
			Category(type: .popular),
			Category(type: .recommendations),
			Category(type: .series)
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
	
	@objc
	private func onSearchButtonTap(sender: UIButton) {
		present(searchController, animated: true)
	}

}

// MARK: - CategoriesViewControllerDelegate

extension MainViewController: CategoriesViewControllerDelegate {
	
	func categoriesViewController(_ viewController: CategoriesViewController, didSelectSlider slider: SliderModel) {
		switch slider.type {
		case .film:
			let detailMovieVC = DetailMovieViewController(id: slider.id)
			navigationController?.pushViewController(detailMovieVC, animated: true)
		case .serial:
			let detailSerialVC = DetailSerialViewController(id: slider.id)
			navigationController?.pushViewController(detailSerialVC, animated: true)
		case .funShow:
			break
		}
	}
	
	func categoriesViewController(_ viewController: CategoriesViewController, didSelectCategory category: Category) {
		switch category.type {
		case .popular:
			tabBarController?.selectedIndex = 1
		case .recommendations:
			tabBarController?.selectedIndex = 1
		case .series:
			tabBarController?.selectedIndex = 2
		case .funShow:
			tabBarController?.selectedIndex = 3
		}
	}
	
	func categoriesViewController(_ viewController: CategoriesViewController, didSelectMovie movie: MovieModel) {
		switch movie.type {
		case .film:
			let detailMovieVC = DetailMovieViewController(id: movie.id)
			navigationController?.pushViewController(detailMovieVC, animated: true)
		case .serial:
			let detailMovieVC = DetailSerialViewController(id: movie.id)
			navigationController?.pushViewController(detailMovieVC, animated: true)
		case .funShow:
			break
		}
	}
}

// MARK: - UISearchResultsUpdating

extension MainViewController: UISearchResultsUpdating {
	
	func updateSearchResults(for searchController: UISearchController) {
		guard let text = searchController.searchBar.text, !text.isEmpty else { return }
		print(text)
		guard text.count > 3 else {
			self.searchController.warningText = "Введите в поле поиска не менее 4-х символов"
			return
		}
		self.searchController.warningText = ""
		videoService.searchMovies(query: text) { [weak self] (result) in
			guard let self = self else { return }
			guard let movies = try? result.get() else { return }
			self.searchResultsController.update(movies: movies)
		}
	}
}

// MARK: - MoviesCollectionViewControllerDelegate

extension MainViewController: MoviesCollectionViewControllerDelegate {
	
	func moviesCollectionViewController(_ viewController: MoviesCollectionViewController, didSelectMovie movie: MovieModel) {
		switch movie.type {
		case .film:
			let detailMovieVC = DetailMovieViewController(id: movie.id)
			navigationController?.pushViewController(detailMovieVC, animated: true)
		case .serial:
			let detailMovieVC = DetailSerialViewController(id: movie.id)
			navigationController?.pushViewController(detailMovieVC, animated: true)
		case .funShow:
			break
		}
	}
}
