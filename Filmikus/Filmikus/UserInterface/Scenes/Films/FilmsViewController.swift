//
//  FilmsViewController.swift
//  Filmikus
//
//  Created by Андрей Козлов on 12.05.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import UIKit

class FilmsViewController: UIViewController {

	private lazy var categoriesViewController = CategoriesViewController()
	
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
		
		title = "Фильмы"
		
		let categories = [
			Category(title: "Артхаус", films: [
				Film(
					imageUrl: "https://via.placeholder.com/150x250/555555/000000",
					title: "Это всего лишь конец света",
					genres: ["Драма"],
					country: "Канада",
					year: "2015",
					censorship: .eighteenPlus
				),
				Film(
					imageUrl: "https://via.placeholder.com/150x200/884444/000000",
					title: "Том на ферме",
					genres: ["Драма", "Триллер"],
					country: "Канада",
					year: "2015",
					censorship: .eighteenPlus
				),
				Film(
					imageUrl: "https://via.placeholder.com/150/228888/000000",
					title: "Свинья",
					genres: ["Драма", "Комедия"],
					country: "Иран",
					year: "2018",
					censorship: .eighteenPlus
				),
				Film(
					imageUrl: "https://via.placeholder.com/150x100/228888/FFFFFF",
					title: "Монстры Юга",
					genres: ["Триллер", "Ужасы"],
					country: "США",
					year: "2015",
					censorship: .eighteenPlus
				)
			]),
			Category(title: "Биографии", films: [
				Film(
					imageUrl: "https://via.placeholder.com/150x100/228888/FFFFFF",
					title: "Дыши ради нас",
					genres: ["Биография", "Драма"],
					country: "Великобритания",
					year: "2015",
					censorship: .sixteenPlus
				),
				Film(
					imageUrl: "https://via.placeholder.com/150x75/F05520/000000",
					title: "Ван Гог",
					genres: ["Биография", "Драма"],
					country: "Великобритания",
					year: "2015",
					censorship: .twelvePlus
				),
				Film(
					imageUrl: "https://via.placeholder.com/150x300/FFFF00/000000",
					title: "Илон Маск",
					genres: ["Биография", "Документальный фильм"],
					country: "Великобритания",
					year: "2015",
					censorship: .twelvePlus
				)
			]),
			Category(title: "Боевики", films: [
				Film(
					imageUrl: "https://via.placeholder.com/150x200/884444/000000",
					title: "Пламя и Цитрон",
					genres: ["Боевик", "Военный"],
					country: "Германия, Дания",
					year: "2015",
					censorship: .sixteenPlus
				)
			]),
			Category(title: "Военные и политические", films: [
				Film(
					imageUrl: "https://via.placeholder.com/150x300/FFFF00/000000",
					title: "28 панфиловцев",
					genres: ["Военный", "Драма"],
					country: "Россия",
					year: "2016",
					censorship: .twelvePlus
				)
			])
		]
		categoriesViewController.update(categories: categories)
    }
	
	
}
