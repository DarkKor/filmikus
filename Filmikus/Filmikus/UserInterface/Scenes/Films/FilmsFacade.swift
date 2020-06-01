//
//  FilmsFacade.swift
//  Filmikus
//
//  Created by Андрей Козлов on 01.06.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//
import Foundation

class FilmsFacade {
	
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
	
	func getFilmsFilter(completion: @escaping (Result<FilmsFilter, Error>) -> Void) {
		var genresResult: Result<[CategoryModel], Error> = .success([])
		var countriesResult: Result<[CountryModel], Error> = .success([])
		
		let dispatchGroup = DispatchGroup()
		dispatchGroup.enter()
		categoriesService.getMovieCategories { (result) in
			defer {
				dispatchGroup.leave()
			}
			genresResult = result
		}
		
		dispatchGroup.enter()
		countriesService.getFilmCountries { (result) in
			defer {
				dispatchGroup.leave()
			}
			countriesResult = result
		}
		dispatchGroup.notify(queue: .main) {
			let result: Result<FilmsFilter, Error> = genresResult.flatMap { genres in
				countriesResult.map { countries in
					FilmsFilter(genres: genres, countries: countries)
				}
			}
			completion(result)
		}
	}
	
	func getFilms(with filter: FilterModel = FilterModel(), completion: @escaping (Result<MoviesModel, Error>) -> Void) {
		videosService.getMovies(of: .film, with: filter) { (result) in
			completion(result)
		}
	}
}
