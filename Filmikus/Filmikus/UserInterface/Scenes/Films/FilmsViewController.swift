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
    }
	
	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
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

extension FilmsViewController: FilterViewControllerDelegate {
	
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

extension FilmsViewController: FilmsCollectionViewControllerDelegate {
	
	func filmsCollectionViewController(_ viewController: FilmsCollectionViewController, didSelectFilm film: Film) {
		let detailFilmVC = DetailFilmViewController(film: film)
		navigationController?.pushViewController(detailFilmVC, animated: true)
	}
}
