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
	
	private lazy var categoriesViewController = CategoriesViewController()
	
	override func loadView() {
		view = UIView()
		addChild(categoriesViewController)
		view.addSubview(categoriesViewController.view)
		categoriesViewController.didMove(toParent: self)
		
		categoriesViewController.view.snp.makeConstraints {
			$0.edges.equalToSuperview()
		}
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		
		let categories = [
			Category(title: "Популярное", films: [
				Film(
					imageUrl: "",
					title: "Дурак",
					genres: ["Драма", "Криминал"],
					country: "Россия",
					year: "2015",
					censorship: .sixteenPlus
				),
				Film(
					imageUrl: "https://via.placeholder.com/150x200/884444/000000",
					title: "Дурак",
					genres: ["Драма", "Криминал"],
					country: "Россия",
					year: "2015",
					censorship: .sixteenPlus
				),
				Film(
					imageUrl: "https://via.placeholder.com/150/228888/000000",
					title: "Дурак",
					genres: ["Драма", "Криминал"],
					country: "Россия",
					year: "2015",
					censorship: .sixteenPlus
				),
				Film(
					imageUrl: "https://via.placeholder.com/150x100/228888/FFFFFF",
					title: "Дурак",
					genres: ["Драма", "Криминал"],
					country: "Россия",
					year: "2015",
					censorship: .sixteenPlus
				),
				Film(
					imageUrl: "https://via.placeholder.com/150x75/F05520/000000",
					title: "Дурак",
					genres: ["Драма", "Криминал"],
					country: "Россия",
					year: "2015",
					censorship: .sixteenPlus
				),
				Film(
					imageUrl: "https://via.placeholder.com/150x300/FFFF00/000000",
					title: "Дурак",
					genres: ["Драма", "Криминал"],
					country: "Россия",
					year: "2015",
					censorship: .sixteenPlus
				)
			]),
			Category(title: "Рекомендуем", films: [
				Film(
					imageUrl: "https://via.placeholder.com/150x100/228888/FFFFFF",
					title: "Дурак",
					genres: ["Драма", "Криминал"],
					country: "Россия",
					year: "2015",
					censorship: .sixteenPlus
				)
			]),
			Category(title: "Фильмы", films: [
				Film(
					imageUrl: "https://via.placeholder.com/150x200/884444/000000",
					title: "Дурак",
					genres: ["Драма", "Криминал"],
					country: "Россия",
					year: "2015",
					censorship: .sixteenPlus
				)
			]),
			Category(title: "Сериалы", films: [
				Film(
					imageUrl: "https://via.placeholder.com/150x300/FFFF00/000000",
					title: "Дурак",
					genres: ["Драма", "Криминал"],
					country: "Россия",
					year: "2015",
					censorship: .sixteenPlus
				)
			])
		]
		categoriesViewController.update(categories: categories)
    }

}
