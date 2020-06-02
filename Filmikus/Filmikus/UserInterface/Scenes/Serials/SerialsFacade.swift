//
//  SerialsFacade.swift
//  Filmikus
//
//  Created by Андрей Козлов on 02.06.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import Foundation

class SerialsFacade {
	
	private let categoriesService: CategoriesServiceType
	private let countriesService: CountriesServiceType
	private let videosService: VideosServiceType
	
	init(
		categoriesService: CategoriesServiceType = CategoriesService(),
		countriesService: CountriesServiceType = CountriesService(),
		videosService: VideosServiceType = VideosService()
	) {
		self.categoriesService = categoriesService
		self.countriesService = countriesService
		self.videosService = videosService
	}
	
	func getFilmsFilterItems(completion: @escaping (Result<FilmsFilterItems, Error>) -> Void) {
		var genresResult: Result<[CategoryModel], Error> = .success([])
		var countriesResult: Result<[CountryModel], Error> = .success([])
		
		let dispatchGroup = DispatchGroup()
		dispatchGroup.enter()
		categoriesService.getSeriesCategories { (result) in
			defer {
				dispatchGroup.leave()
			}
			genresResult = result
		}
		
		dispatchGroup.enter()
		countriesService.getSerialCountries { (result) in
			defer {
				dispatchGroup.leave()
			}
			countriesResult = result
		}
		dispatchGroup.notify(queue: .main) {
			let result: Result<FilmsFilterItems, Error> = genresResult.flatMap { genres in
				countriesResult.map { countries in
					FilmsFilterItems(genres: genres, countries: countries)
				}
			}
			completion(result)
		}
	}
	
	func getSerials(with filter: FilterModel = FilterModel(), completion: @escaping (Result<MoviesModel, Error>) -> Void) {
		videosService.getMovies(of: .serial, with: filter) { (result) in
			completion(result)
		}
	}
}
