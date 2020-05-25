//
//  SerialsViewController.swift
//  Filmikus
//
//  Created by Андрей Козлов on 13.05.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import UIKit

class SerialsViewController: UIViewController {
	
	private lazy var filmsCollectionViewController: FilmsCollectionViewController = {
		let viewController = FilmsCollectionViewController()
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
		
		let films = [
				Film(
					imageUrl: "https://filmikus.com/images/2/1/middle/img.jpg",
					title: "Улики",
					genres: ["Криминал", "Детектив"],
					country: "Россия",
					year: "2015",
					censorship: .eighteenPlus
				),
				Film(
					imageUrl: "https://filmikus.com/images/2/2/middle/img.jpg",
					title: "Полицейский участок",
					genres: ["Детектив"],
					country: "Россия",
					year: "2015",
					censorship: .eighteenPlus
				),
				Film(
					imageUrl: "https://filmikus.com/images/2/3/middle/img.jpg",
					title: "Непридуманная жизнь",
					genres: ["Драма", "Биография"],
					country: "Россия",
					year: "2015",
					censorship: .eighteenPlus
				),
				Film(
					imageUrl: "https://filmikus.com/images/2/4/middle/img.jpg",
					title: "Мой любимый папа",
					genres: ["Драма"],
					country: "Россия",
					year: "2014",
					censorship: .sixteenPlus
				),
				Film(
					imageUrl: "https://filmikus.com/images/2/5/middle/img.jpg",
					title: "Стрелок",
					genres: ["Боевик"],
					country: "Россия",
					year: "2012",
					censorship: .twelvePlus
				),
				Film(
					imageUrl: "https://filmikus.com/images/2/8/middle/img.jpg",
					title: "Сибирь",
					genres: ["Драма", "История"],
					country: "СССР",
					year: "1976",
					censorship: .sixteenPlus
				),
				Film(
					imageUrl: "https://filmikus.com/images/2/10/middle/img.jpg",
					title: "Мужество",
					genres: ["Драма", "История"],
					country: "СССР",
					year: "1980",
					censorship: .sixteenPlus
				),
				Film(
					imageUrl: "https://filmikus.com/images/2/13/middle/img.jpg",
					title: "Фортитьюд",
					genres: ["Драма"],
					country: "Великобритания",
					year: "2015",
					censorship: .sixteenPlus
				),
				Film(
					imageUrl: "https://filmikus.com/images/2/20/middle/img.jpg",
					title: "Мата Хари",
					genres: ["Драма", "Биография"],
					country: "Россия",
					year: "2016",
					censorship: .twelvePlus
				)
		]
		filmsCollectionViewController.update(films: films)
		
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

extension SerialsViewController: FilmsCollectionViewControllerDelegate {
	
	func filmsCollectionViewController(_ viewController: FilmsCollectionViewController, didSelectFilter item: FilterItem) {
		let selectItemViewController = SelectItemViewController(items: ["Россия", "Украина", "Белорусь"]) { selectedItem in
			var item = item
			let content = item.content
			item.content = FilterContentItem(title: content.title, detail: selectedItem)
			viewController.update(filterItem: item)
		}
		navigationController?.pushViewController(selectItemViewController, animated: true)
	}
	
	func filmsCollectionViewControllerShouldShowActivity(_ viewController: FilmsCollectionViewController) -> Bool {
		return false
	}
	
	func filmsCollectionViewController(_ viewController: FilmsCollectionViewController, didSelectFilm film: Film) {
		let detailFilmVC = DetailFilmViewController(film: film)
		navigationController?.pushViewController(detailFilmVC, animated: true)
	}
}
