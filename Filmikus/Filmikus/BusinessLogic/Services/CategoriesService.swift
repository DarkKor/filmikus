//
//  CategoriesService.swift
//  Filmikus
//
//  Created by Андрей Козлов on 28.05.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import Moya

protocol CategoriesServiceType {
	func getMovieCategories(completion: @escaping (Result<[CategoryModel], Error>) -> Void)
	func getSeriesCategories(completion: @escaping (Result<[CategoryModel], Error>) -> Void)
	func getFunCategories(completion: @escaping (Result<[CategoryModel], Error>) -> Void)
}

class CategoriesService: CategoriesServiceType {
	
	private let provider: MoyaProvider<CategoriesAPI>
	
	init(provider: MoyaProvider<CategoriesAPI> = MoyaProvider<CategoriesAPI>()) {
		self.provider = provider
	}
	
	func getMovieCategories(completion: @escaping (Result<[CategoryModel], Error>) -> Void) {
		provider.request(.movies) { (result) in
			completion(
				result.mapError { $0 }.flatMap { response in
					Result { try response.map([CategoryModel].self) }
				}
			)
		}
	}
	
	func getSeriesCategories(completion: @escaping (Result<[CategoryModel], Error>) -> Void) {
		provider.request(.series) { (result) in
			completion(
				result.mapError { $0 }.flatMap { response in
					Result { try response.map([CategoryModel].self) }
				}
			)
		}
	}
	
	func getFunCategories(completion: @escaping (Result<[CategoryModel], Error>) -> Void) {
		provider.request(.fun) { (result) in
			completion(
				result.mapError { $0 }.flatMap { response in
					Result { try response.map([CategoryModel].self) }
				}
			)
		}
	}
}
