//
//  VideosService.swift
//  Filmikus
//
//  Created by Андрей Козлов on 28.05.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import Moya

protocol VideosServiceType {
	func getMovies(with filter: FilterModel, completion: @escaping (Result<MoviesModel, Error>) -> Void)
	func getSeries(with filter: FilterModel, completion: @escaping (Result<MoviesModel, Error>) -> Void)
	func getFun(with filter: FilterModel, completion: @escaping (Result<MoviesModel, Error>) -> Void)
	func searchMovies(query: String, completion:  @escaping (Result<[MovieModel], Error>) -> Void)
}

class VideosService: VideosServiceType {
	
	private let provider: MoyaProvider<VideosAPI>
	
	init(provider: MoyaProvider<VideosAPI> = MoyaProvider<VideosAPI>()) {
		self.provider = provider
	}
	
	func getMovies(with filter: FilterModel, completion: @escaping (Result<MoviesModel, Error>) -> Void) {
		provider.request(.movies(filter: filter)) { (result) in
			completion(
				result.mapError { $0 }.flatMap { response in
					Result { try response.map(MoviesModel.self) }
				}
			)
		}
	}
	
	func getSeries(with filter: FilterModel, completion: @escaping (Result<MoviesModel, Error>) -> Void) {
		provider.request(.series(filter: filter)) { (result) in
			completion(
				result.mapError { $0 }.flatMap { response in
					Result { try response.map(MoviesModel.self) }
				}
			)
		}
	}
	
	func getFun(with filter: FilterModel, completion: @escaping (Result<MoviesModel, Error>) -> Void) {
		provider.request(.fun(filter: filter)) { (result) in
			completion(
				result.mapError { $0 }.flatMap { response in
					Result { try response.map(MoviesModel.self) }
				}
			)
		}
	}
	
	func searchMovies(query: String, completion: @escaping (Result<[MovieModel], Error>) -> Void) {
		provider.request(.search(query: query)) { (result) in
			completion(
				result.mapError { $0 }.flatMap { response in
					Result { try response.map([MovieModel].self) }
				}
			)
		}
	}
	
	
}
