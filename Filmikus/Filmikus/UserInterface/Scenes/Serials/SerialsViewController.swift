//
//  SerialsViewController.swift
//  Filmikus
//
//  Created by Андрей Козлов on 13.05.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import UIKit

class SerialsViewController: UIViewController {
	
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

        title = "Сериалы"
		
		let filterItems: [FilterItem] = [
			.genre(FilterContentItem(title: "Жанр", detail: "Все")),
			.country(FilterContentItem(title: "Страна", detail: "Все")),
			.year(FilterContentItem(title: "Год", detail: "Все")),
			.quality(FilterQualityContentItem(title: "Качество")),
			.sort(FilterContentItem(title: "Сортировать", detail: "По популярности"))
		]
		filmsCollectionViewController.update(filterItems: filterItems)
    }
	
}

// MARK: - FilmsCollectionViewControllerDelegate

extension SerialsViewController: MoviesCollectionViewControllerDelegate {
	
	func moviesCollectionViewController(_ viewController: MoviesCollectionViewController, didSelectFilter item: FilterItem) {
//		let selectedItems = ["Россия", "Украина", "Белорусь"]
//		let selectItemViewController = SelectItemViewController(items: selectedItems) { selectedIndex in
//			var item = item
//			let content = item.content
//			item.content = FilterContentItem(title: content.title, detail: selectedItems[selectedIndex])
//			viewController.update(filterItem: item)
//		}
//		navigationController?.pushViewController(selectItemViewController, animated: true)
	}
	
	func moviesCollectionViewController(_ viewController: MoviesCollectionViewController, didSelectQuality quality: VideoQuality) {
		
	}
	
	func moviesCollectionViewController(_ viewController: MoviesCollectionViewController, didDeselectQuality quality: VideoQuality) {
		
	}
	
	func moviesCollectionViewControllerShouldShowActivity(_ viewController: MoviesCollectionViewController) -> Bool {
		return false
	}
	
	func moviesCollectionViewController(_ viewController: MoviesCollectionViewController, didSelectMovie film: MovieModel) {
		let detailFilmVC = DetailMovieViewController(movie: film)
		navigationController?.pushViewController(detailFilmVC, animated: true)
	}
}
