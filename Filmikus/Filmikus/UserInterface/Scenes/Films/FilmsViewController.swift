//
//  FilmsViewController.swift
//  Filmikus
//
//  Created by Андрей Козлов on 12.05.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import UIKit

class FilmsViewController: UIViewController {
		
	private lazy var filmsCollectionViewController: MoviesCollectionViewController = {
		let viewController = MoviesCollectionViewController()
		viewController.delegate = self
		return viewController
	}()
	
	override func loadView() {
		view = UIView()
		view.backgroundColor = .appLightGray
		
		addChild(filmsCollectionViewController)
		view.addSubview(filmsCollectionViewController.view)
		filmsCollectionViewController.didMove(toParent: self)
		
		filmsCollectionViewController.view.snp.makeConstraints {
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
		filmsCollectionViewController.update(filterItems: filterItems)
    }
}

// MARK: - FilmsCollectionViewControllerDelegate

extension FilmsViewController: MoviesCollectionViewControllerDelegate {
	
	func moviesCollectionViewController(_ viewController: MoviesCollectionViewController, didSelectFilter item: FilterItem) {
		var selectItems: [String] = []
		switch item {
		case .genre:
			selectItems = ["Драма", "Комедия", "Биография"]
		case .country:
			selectItems = ["Россия", "Украина", "Белорусь"]
		case .year:
			selectItems = (1900 ... 2020).map { String($0) }
		case .quality:
			selectItems = ["SD", "HD", "fullHD"]
		case .sort:
			selectItems = ["По популярности", "По новизне"]
		}
		let selectItemViewController = SelectItemViewController(items: selectItems) { selectedItem in
			var item = item
			let content = item.content
			item.content = FilterContentItem(title: content.title, detail: selectedItem)
			viewController.update(filterItem: item)
		}
		navigationController?.pushViewController(selectItemViewController, animated: true)
	}
	
	func moviesCollectionViewControllerShouldShowActivity(_ viewController: MoviesCollectionViewController) -> Bool {
		return true
	}
	
	func moviesCollectionViewController(_ viewController: MoviesCollectionViewController, didSelectMovie movie: MovieModel) {
		let detailFilmVC = DetailMovieViewController(movie: movie)
		navigationController?.pushViewController(detailFilmVC, animated: true)
	}
}


