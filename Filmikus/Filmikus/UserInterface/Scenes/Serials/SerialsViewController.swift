//
//  SerialsViewController.swift
//  Filmikus
//
//  Created by Андрей Козлов on 13.05.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import UIKit

class SerialsViewController: UIViewController {

	private lazy var scrollView = UIScrollView()
	private lazy var containerView = UIView()
	
	private lazy var filterViewController: FilterViewController = {
		let viewController = FilterViewController()
		viewController.delegate = self
		viewController.tableView.isScrollEnabled = false
		return viewController
	}()
	
	private lazy var filmsCollectionViewController: FilmsCollectionViewController = {
		let viewController = FilmsCollectionViewController()
		viewController.delegate = self
		viewController.collectionView.isScrollEnabled = false
		return viewController
	}()
	
	override func loadView() {
		view = UIView()
		view.backgroundColor = .appLightGray
		
		view.addSubview(scrollView)
		scrollView.addSubview(containerView)
		
		addChild(filterViewController)
		containerView.addSubview(filterViewController.view)
		filterViewController.didMove(toParent: self)
		filterViewController.view.snp.makeConstraints {
			$0.top.left.right.equalToSuperview()
			$0.height.equalTo(300)
		}
		
		addChild(filmsCollectionViewController)
		containerView.addSubview(filmsCollectionViewController.view)
		filmsCollectionViewController.didMove(toParent: self)
		
		scrollView.showsVerticalScrollIndicator = false
		scrollView.translatesAutoresizingMaskIntoConstraints = false
		let frameGuide = scrollView.frameLayoutGuide
		let contentGuide = scrollView.contentLayoutGuide
		
		frameGuide.snp.makeConstraints {
			$0.edges.equalTo(view)
			$0.width.equalTo(contentGuide)
		}
		
		containerView.snp.makeConstraints {
			$0.edges.equalTo(contentGuide)
		}
		
		filmsCollectionViewController.view.snp.makeConstraints {
			$0.top.equalTo(filterViewController.view.snp.bottom)
			$0.left.bottom.right.equalToSuperview()
			$0.height.equalTo(100)
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
    }
	
	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		print("filmsCollection: \(filmsCollectionViewController.collectionView.contentSize)")
		print("scrollView: \(scrollView.contentSize)")
		let filmsHeight = filmsCollectionViewController.collectionView.contentSize.height
		if filmsHeight > 0 {
			filmsCollectionViewController.view.snp.updateConstraints {
				$0.height.equalTo(filmsHeight)
			}
		}
		let filterHeight = filterViewController.tableView.contentSize.height
		if filterHeight > 0 {
			filterViewController.view.snp.updateConstraints {
				$0.height.equalTo(filterHeight)
			}
		}
		scrollView.contentSize.height = filmsHeight + filterHeight
	}

}

// MARK: - FilterViewControllerDelegate

extension SerialsViewController: FilterViewControllerDelegate {
	
	func filterViewController(_ viewController: FilterViewController, didSelectFilterItem item: FilterItem) {
		let selectItemViewController = SelectItemViewController(items: ["Россия", "Украина", "Белорусь"]) { selectedItem in
			var item = item
			let content = item.content
			item.content = FilterContentItem(title: content.title, detail: selectedItem)
			viewController.updateFilter(item: item)
		}
		navigationController?.pushViewController(selectItemViewController, animated: true)
	}
}

// MARK: - FilmsCollectionViewControllerDelegate

extension SerialsViewController: FilmsCollectionViewControllerDelegate {
	
	func filmsCollectionViewController(_ viewController: FilmsCollectionViewController, didSelectFilm film: Film) {
		let detailFilmVC = DetailFilmViewController(film: film)
		navigationController?.pushViewController(detailFilmVC, animated: true)
	}
}
