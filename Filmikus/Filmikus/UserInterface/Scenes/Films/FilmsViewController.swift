//
//  FilmsViewController.swift
//  Filmikus
//
//  Created by Андрей Козлов on 12.05.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import UIKit

class FilmsViewController: UIViewController {
	
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
		
		title = "Фильмы"
		navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .plain, target: self, action: #selector(onButtonFilterTap))
		let films = [
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
			),
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
			),
			Film(
				imageUrl: "https://via.placeholder.com/150x200/884444/000000",
				title: "Пламя и Цитрон",
				genres: ["Боевик", "Военный"],
				country: "Германия, Дания",
				year: "2015",
				censorship: .sixteenPlus
			),
			Film(
				imageUrl: "https://via.placeholder.com/150x300/FFFF00/000000",
				title: "28 панфиловцев",
				genres: ["Военный", "Драма"],
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
	
	@objc
	private func onButtonFilterTap(sender: UIBarButtonItem) {
		
	}
	
	
}

// MARK: - FilterViewControllerDelegate

extension FilmsViewController: FilterViewControllerDelegate {
	
	func filterViewController(_ viewController: FilterViewController, didSelectFilterItem item: FilterItem) {
		print(item)
		var item = item
		let content = item.content
		item.content = FilterContentItem(title: content.title, detail: content.title)
		viewController.updateFilter(item: item)
	}
}

// MARK: - FilmsCollectionViewControllerDelegate

extension FilmsViewController: FilmsCollectionViewControllerDelegate {
	
	func filmsCollectionViewController(_ viewController: FilmsCollectionViewController, didSelectFilm film: Film) {
		let detailFilmVC = DetailFilmViewController(film: film)
		navigationController?.pushViewController(detailFilmVC, animated: true)
	}
}
