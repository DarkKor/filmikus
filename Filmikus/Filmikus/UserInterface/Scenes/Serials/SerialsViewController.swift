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
					imageUrl: "https://via.placeholder.com/150x250/555555/000000",
					title: "Карамель",
					genres: ["Комедия"],
					country: "Россия",
					year: "2011",
					censorship: .eighteenPlus
				),
				Film(
					imageUrl: "https://via.placeholder.com/150x200/884444/000000",
					title: "Трое в Коми",
					genres: ["Комедия", "Мелодрама"],
					country: "Россия",
					year: "2013",
					censorship: .eighteenPlus
				),
				Film(
					imageUrl: "https://via.placeholder.com/150/228888/000000",
					title: "Маленький человек большого офиса",
					genres: ["Комедия"],
					country: "Россия",
					year: "2009",
					censorship: .eighteenPlus
				),
				Film(
					imageUrl: "https://via.placeholder.com/150x100/228888/FFFFFF",
					title: "Сектор зеро",
					genres: ["Фантастика", "Драма"],
					country: "Фарнция",
					year: "2016",
					censorship: .sixteenPlus
				),
				Film(
					imageUrl: "https://via.placeholder.com/150x75/F05520/000000",
					title: "Секунда до",
					genres: ["Фантастика"],
					country: "Россия",
					year: "2008",
					censorship: .twelvePlus
				),
				Film(
					imageUrl: "https://via.placeholder.com/150x200/884444/000000",
					title: "Непридуманная жизнь",
					genres: ["Драма", "Биография"],
					country: "Россия",
					year: "2015",
					censorship: .sixteenPlus
				),
				Film(
					imageUrl: "https://via.placeholder.com/150x200/228888/000000",
					title: "Сибирь",
					genres: ["Драма", "История"],
					country: "СССР",
					year: "1976",
					censorship: .sixteenPlus
				),
				Film(
					imageUrl: "https://via.placeholder.com/150x200/181818/000000",
					title: "Предел возможного",
					genres: ["Драма"],
					country: "СССР",
					year: "1984",
					censorship: .sixteenPlus
				),
				Film(
					imageUrl: "https://via.placeholder.com/150x300/F8F8F8/000000",
					title: "Фортитьюд",
					genres: ["Драма", "Триллер"],
					country: "Великобритания",
					year: "2015",
					censorship: .twelvePlus
				),
				Film(
					imageUrl: "https://via.placeholder.com/150x300/880055/000000",
					title: "Сплит",
					genres: ["Триллер", "Мелодрама"],
					country: "Украина",
					year: "2011",
					censorship: .twelvePlus
				),
				Film(
					imageUrl: "https://via.placeholder.com/150x300/991399/000000",
					title: "Палач",
					genres: ["Триллер", "Криминал"],
					country: "Россия",
					year: "2014",
					censorship: .twelvePlus
				)
		]
		filmsCollectionViewController.update(films: films)
    }

}

// MARK: - FilmsCollectionViewControllerDelegate

extension SerialsViewController: FilmsCollectionViewControllerDelegate {
	
	func filmsCollectionViewController(_ viewController: FilmsCollectionViewController, didSelectFilm film: Film) {
		let detailFilmVC = DetailFilmViewController(film: film)
		navigationController?.pushViewController(detailFilmVC, animated: true)
	}
}
