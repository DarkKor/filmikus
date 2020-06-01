//
//  FilmsViewController.swift
//  Filmikus
//
//  Created by Андрей Козлов on 12.05.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import UIKit

class FilmsViewController: UIViewController {
	
	private let facade = FilmsFacade()
	
	private var filmsFilter = FilmsFilter()
		
	private lazy var moviesCollectionViewController: MoviesCollectionViewController = {
		let viewController = MoviesCollectionViewController()
		viewController.delegate = self
		return viewController
	}()
	
	override func loadView() {
		view = UIView()
		view.backgroundColor = .appLightGray
		
		addChild(moviesCollectionViewController)
		view.addSubview(moviesCollectionViewController.view)
		moviesCollectionViewController.didMove(toParent: self)
		
		moviesCollectionViewController.view.snp.makeConstraints {
			$0.edges.equalToSuperview()
		}
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		
		title = "Фильмы"
		
		let filterItems: [FilterItem] = [
			.genre(FilterContentItem(title: "Жанр", detail: "Все")),
			.country(FilterContentItem(title: "Страна", detail: "Все")),
			.year(FilterContentItem(title: "Год", detail: "Все")),
			.quality(FilterContentItem(title: "Качество", detail: "Все")),
			.sort(FilterContentItem(title: "Сортировать", detail: "По популярности"))
		]
		moviesCollectionViewController.update(filterItems: filterItems)
		
		facade.getFilmsFilter { [weak self] (result) in
			guard let self = self else { return }
			guard let filmsFilter = try? result.get() else { return }
			self.filmsFilter = filmsFilter
		}
		
		facade.getFilms { [weak self] (result) in
			guard let self = self else { return }
			guard let moviesModel = try? result.get() else { return }
			let movies = moviesModel.items.map {
				MovieModel(id: $0.id, title: $0.title, imageUrl: $0.imageUrl.high, type: .film)
			}
			self.moviesCollectionViewController.update(movies: movies)
		}
		
    }
}

// MARK: - FilmsCollectionViewControllerDelegate

extension FilmsViewController: MoviesCollectionViewControllerDelegate {
	
	func moviesCollectionViewController(_ viewController: MoviesCollectionViewController, didSelectFilter item: FilterItem) {
		var selectItems: [String] = []
		switch item {
		case .genre:
			selectItems = filmsFilter.genres.map { $0.title }
		case .country:
			selectItems = filmsFilter.countries.map { $0.title }
		case .year:
			selectItems = (1924 ... 2020).map { String($0) }
		case .quality:
			selectItems = VideoQuality.allCases.map { $0.description }
		case .sort:
			selectItems = VideoOrder.allCases.map { $0.description }
		}
		
		// Возможно стоит сделать пикер, который будет вылезать внизу экрана, вместо перехода на новый экран.
		let selectItemViewController = SelectItemViewController(items: selectItems) { selectedItem in
			var item = item
			let content = item.content
			item.content = FilterContentItem(title: content.title, detail: selectedItem)
			viewController.update(filterItem: item)
		}
		navigationController?.pushViewController(selectItemViewController, animated: true)
	}
	
	func moviesCollectionViewControllerShouldShowActivity(_ viewController: MoviesCollectionViewController) -> Bool {
		return false
	}
	
	func moviesCollectionViewController(_ viewController: MoviesCollectionViewController, didSelectMovie movie: MovieModel) {
		let detailFilmVC = DetailMovieViewController(movie: movie)
		navigationController?.pushViewController(detailFilmVC, animated: true)
	}
}


