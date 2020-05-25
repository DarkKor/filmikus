//
//  FilmsViewController.swift
//  Filmikus
//
//  Created by Андрей Козлов on 12.05.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import UIKit

class FilmsViewController: UIViewController {
	
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
		
		title = "Фильмы"
		let films = [
			Film(
				imageUrl: "https://filmikus.com/images/1/30/middle/img.jpg",
				title: "1+1",
				genres: ["Комедия", "Драма"],
				country: "Франция",
				year: "2011",
				censorship: .sixteenPlus
			),
			Film(
				imageUrl: "https://filmikus.com/images/1/676/middle/img.jpg",
				title: "Девочка и дельфин",
				genres: ["Мультфильм"],
				country: "СССР",
				year: "1979",
				censorship: .eighteenPlus
			),
			Film(
				imageUrl: "https://filmikus.com/images/1/446/middle/img.jpg",
				title: "Женщины",
				genres: ["Драма", "Мелодрама"],
				country: "СССР",
				year: "1965",
				censorship: .eighteenPlus
			),
			Film(
				imageUrl: "https://filmikus.com/images/1/331/middle/img.jpg",
				title: "Шинель",
				genres: ["Драма"],
				country: "СССР",
				year: "1959",
				censorship: .eighteenPlus
			),
			Film(
				imageUrl: "https://filmikus.com/images/1/447/middle/img.jpg",
				title: "Доживем до понедельника",
				genres: ["Драма", "Мелодрама"],
				country: "СССР",
				year: "1968",
				censorship: .sixteenPlus
			),
			Film(
				imageUrl: "https://filmikus.com/images/1/448/middle/img.jpg",
				title: "Дело было в Пенькове",
				genres: ["Биография", "Драма"],
				country: "СССР",
				year: "1957",
				censorship: .twelvePlus
			),
			Film(
				imageUrl: "https://filmikus.com/images/1/449/middle/img.jpg",
				title: "Варвара-краса",
				genres: ["Комедия", "Драма"],
				country: "СССР",
				year: "1970",
				censorship: .twelvePlus
			),
			Film(
				imageUrl: "https://filmikus.com/images/1/450/middle/img.jpg",
				title: "Добровольцы",
				genres: ["Боевик", "Военный"],
				country: "СССР",
				year: "1958",
				censorship: .sixteenPlus
			),
			Film(
				imageUrl: "https://filmikus.com/images/1/454/middle/img.jpg",
				title: "Евдокия",
				genres: ["Драма"],
				country: "СССР",
				year: "1961",
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

extension FilmsViewController: FilmsCollectionViewControllerDelegate {
	
	func filmsCollectionViewController(_ viewController: FilmsCollectionViewController, didSelectFilter item: FilterItem) {
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
	
	func filmsCollectionViewControllerShouldShowActivity(_ viewController: FilmsCollectionViewController) -> Bool {
		return true
	}
	
	func filmsCollectionViewController(_ viewController: FilmsCollectionViewController, didSelectFilm film: Film) {
		let detailFilmVC = DetailFilmViewController(film: film)
		navigationController?.pushViewController(detailFilmVC, animated: true)
	}
}


