//
//  FilmsViewController.swift
//  Filmikus
//
//  Created by Андрей Козлов on 12.05.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import UIKit

class FilmsViewController: UIViewController {
	
	private let facade = FilmsFacade()
	private var filter = FilterModel()
	private var filmsFilter = FilmsFilter()
		
	private lazy var moviesCollectionViewController: MoviesCollectionViewController = {
		let viewController = MoviesCollectionViewController()
		viewController.delegate = self
		return viewController
	}()
	
	private lazy var activityIndicator = UIActivityIndicatorView()
	
	override func loadView() {
		view = UIView()
		view.backgroundColor = .appLightGray
		
		addChild(moviesCollectionViewController)
		view.addSubview(moviesCollectionViewController.view)
		moviesCollectionViewController.didMove(toParent: self)
		
		view.addSubview(activityIndicator)
		
		moviesCollectionViewController.view.snp.makeConstraints {
			$0.edges.equalToSuperview()
		}
		activityIndicator.snp.makeConstraints {
			$0.center.equalToSuperview()
		}
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		
		title = "Фильмы"
		
		facade.getFilmsFilter { [weak self] (result) in
			guard let self = self else { return }
			guard let filmsFilter = try? result.get() else { return }
			self.filmsFilter = filmsFilter
			let filterItems: [FilterItem] = [
				.genre(FilterContentItem(title: "Жанр", detail: "Все")),
				.country(FilterContentItem(title: "Страна", detail: "Все")),
				.year(FilterContentItem(title: "Год", detail: "Все")),
				.quality(FilterQualityContentItem(title: "Качество")),
				.sort(FilterContentItem(title: "Сортировать", detail: "По популярности"))
			]
			self.moviesCollectionViewController.update(filterItems: filterItems)
		}
		
		loadFilms()
    }
	
	func loadFilms() {
		activityIndicator.startAnimating()
		facade.getFilms(with: filter) { [weak self] (result) in
			guard let self = self else { return }
			self.activityIndicator.stopAnimating()
			guard let moviesModel = try? result.get() else { return }
			let movies = moviesModel.items.map {
				MovieModel(id: $0.id, title: $0.title, imageUrl: $0.imageUrl.high, type: .film)
			}
			self.moviesCollectionViewController.update(movies: movies)
		}
	}
}

// MARK: - FilmsCollectionViewControllerDelegate

extension FilmsViewController: MoviesCollectionViewControllerDelegate {
	
	func moviesCollectionViewController(_ viewController: MoviesCollectionViewController, didSelectFilter item: FilterItem) {
		switch item {
		case .genre:
			let genres = filmsFilter.genres.map { $0.title }
			let selectItemViewController = SelectItemViewController(items: genres) { genreItem in
				let title: String
				let categoryId: Int?
				switch genreItem {
				case .all:
					title = "Все"
					categoryId = nil
				case let .itemIndex(index):
					let genre = self.filmsFilter.genres[index]
					title = genre.title
					categoryId = genre.id
				}
				let content = FilterContentItem(title: "Жанр", detail: title)
				viewController.update(filterItem: .genre(content))
				self.filter.categoryId = categoryId
				self.loadFilms()
			}
			navigationController?.pushViewController(selectItemViewController, animated: true)
		case .country:
			let countries = filmsFilter.countries.map { $0.title }
			let selectItemViewController = SelectItemViewController(items: countries) { countryItem in
				let title: String
				let countryId: Int?
				switch countryItem {
				case .all:
					title = "Все"
					countryId = nil
				case let .itemIndex(index):
					let country = self.filmsFilter.countries[index]
					title = country.title
					countryId = country.id
				}
				let content = FilterContentItem(title: "Страна", detail: title)
				viewController.update(filterItem: .country(content))
				self.filter.countryId = countryId
				self.loadFilms()
			}
			navigationController?.pushViewController(selectItemViewController, animated: true)
		case .year:
			let dates = (1924 ... 2020).map { Int($0) }
			let vc = SelectItemPickerViewController(items: dates) { (selectedDate) in
				let content: FilterContentItem
				switch selectedDate {
				case .all:
					content = FilterContentItem(title: "Год", detail: "Все")
					self.filter.startDate = nil
					self.filter.endDate = nil
				case let .interval(from, to):
					content = FilterContentItem(title: "Год", detail: "\(from) - \(to)")
					self.filter.startDate = from
					self.filter.endDate = to
				}
				viewController.update(filterItem: .year(content))
				self.loadFilms()
			}
			navigationController?.pushViewController(vc, animated: true)
			return
		case .quality:
//			selectItems = VideoQuality.allCases.map { $0.description }
			break
		case .sort:
			let sorts = VideoOrder.allCases.map { $0.description }
			let selectItemViewController = SelectItemViewController(items: sorts) { sortItem in
				let title: String
				let order: VideoOrder?
				switch sortItem {
				case .all:
					let videoOrder = VideoOrder.popular
					title = videoOrder.description
					order = nil
				case let .itemIndex(index):
					let videoOrder = VideoOrder.allCases[index]
					title = videoOrder.description
					order = videoOrder
				}
				let content = FilterContentItem(title: "Сортировать", detail: title)
				viewController.update(filterItem: .sort(content))
				self.filter.videoOrder = order
				self.loadFilms()
			}
			navigationController?.pushViewController(selectItemViewController, animated: true)
		}
	}
	
	func moviesCollectionViewController(_ viewController: MoviesCollectionViewController, didSelectQuality quality: VideoQuality) {
		filter.qualities.insert(quality)
		loadFilms()
	}
	
	func moviesCollectionViewController(_ viewController: MoviesCollectionViewController, didDeselectQuality quality: VideoQuality) {
		filter.qualities.remove(quality)
		loadFilms()
	}
	
	func moviesCollectionViewControllerShouldShowActivity(_ viewController: MoviesCollectionViewController) -> Bool {
		return false
	}
	
	func moviesCollectionViewController(_ viewController: MoviesCollectionViewController, didSelectMovie movie: MovieModel) {
		let detailFilmVC = DetailMovieViewController(movie: movie)
		navigationController?.pushViewController(detailFilmVC, animated: true)
	}
}
