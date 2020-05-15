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
	
	private lazy var categoriesViewController: CategoriesViewController = {
		let viewController = CategoriesViewController()
		viewController.delegate = self
		return viewController
	}()
	private lazy var searchController = UISearchController(searchResultsController: nil)

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
		navigationItem.searchController = searchController

		title = "Главная"
		
		let categories = [
			Category(title: "Популярное", films: [
				Film(
					imageUrl: "https://filmikus.com/images/1/30/middle/img.jpg",
					title: "1+1",
					genres: ["Комедия", "Драма"],
					country: "Франция",
					year: "2011",
					censorship: .sixteenPlus
				),
				Film(
					imageUrl: "https://filmikus.com/images/1/373/middle/img.jpg",
					title: "Дурак",
					genres: ["Драма", "Россия"],
					country: "Россия",
					year: "2014",
					censorship: .sixteenPlus
				),
				Film(
					imageUrl: "https://filmikus.com/images/1/592/middle/img.jpg",
					title: "Танцовщик",
					genres: ["Биография", "Документальный"],
					country: "Россия",
					year: "2016",
					censorship: .sixteenPlus
				),
				Film(
					imageUrl: "https://filmikus.com/images/1/722/middle/img.jpg",
					title: "Месть от кутюр",
					genres: ["Комедия", "Драма"],
					country: "Австралия",
					year: "2015",
					censorship: .sixteenPlus
				),
				Film(
					imageUrl: "https://filmikus.com/images/1/723/middle/img.jpg",
					title: "28 панфиловцев",
					genres: ["Драма", "Военный"],
					country: "Россия",
					year: "2016",
					censorship: .sixteenPlus
				)
			]),
			Category(title: "Рекомендуем", films: [
				Film(
					imageUrl: "https://filmikus.com/images/1/15/middle/img.jpg",
					title: "О чем говорят мужчины",
					genres: ["Комедия"],
					country: "Россия",
					year: "2010",
					censorship: .sixteenPlus
				),
				Film(
					imageUrl: "https://filmikus.com/images/1/520/middle/img.jpg",
					title: "Антропоид",
					genres: ["Биография"],
					country: "Франция",
					year: "2016",
					censorship: .sixteenPlus
				),
				Film(
					imageUrl: "https://filmikus.com/images/1/523/middle/img.jpg",
					title: "Хардкор",
					genres: ["Фантастика", "Боевик"],
					country: "Россия",
					year: "2016",
					censorship: .sixteenPlus
				),
				Film(
					imageUrl: "https://filmikus.com/images/1/721/middle/img.jpg",
					title: "Гонка",
					genres: ["Спорт", "Драма"],
					country: "США",
					year: "2013",
					censorship: .sixteenPlus
				)
			]),
			Category(title: "Сериалы", films: [
				Film(
					imageUrl: "https://filmikus.com/images/2/5/middle/img.jpg",
					title: "Стрелок",
					genres: ["Боевик"],
					country: "Россия",
					year: "2012",
					censorship: .sixteenPlus
				)
			]),
			Category(title: "Развлекательное видео", films: [
				Film(
					imageUrl: "https://via.placeholder.com/150x200/884444/000000",
					title: "Дурак",
					genres: ["Драма", "Криминал"],
					country: "Россия",
					year: "2015",
					censorship: .sixteenPlus
				)
			]),
			
		]
		categoriesViewController.update(categories: categories)
    }

}

// MARK: - CategoriesViewControllerDelegate

extension MainViewController: CategoriesViewControllerDelegate {
	
	func categoriesViewController(_ viewController: CategoriesViewController, didSelectFilm film: Film) {
		let detailFilmVC = DetailFilmViewController(film: film)
		navigationController?.pushViewController(detailFilmVC, animated: true)
	}
}
