//
//  MainService.swift
//  Filmikus
//
//  Created by Андрей Козлов on 27.05.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import Moya

protocol MainServiceType: class {
	func getSlider(completion: @escaping (Result<[SliderModel], Error>) -> Void)
	func getPopular(completion: @escaping (Result<[MovieModel], Error>) -> Void)
	func getRecommendations(completion: @escaping (Result<[MovieModel], Error>) -> Void)
	func getSeries(completion: @escaping (Result<[MovieModel], Error>) -> Void)
}

class MainService: MainServiceType {
		
	private let provider: MoyaProvider<MainAPI>
	
	init(provider: MoyaProvider<MainAPI> = MoyaProvider<MainAPI>()) {
		self.provider = provider
	}
	
	func getSlider(completion: @escaping (Result<[SliderModel], Error>) -> Void) {
		provider.request(.slider) { (result) in
			completion(
				result.mapError { $0 }.flatMap { response in
					Result { try response.map([SliderModel].self) }
				}
			)
		}
	}
	
	func getPopular(completion: @escaping (Result<[MovieModel], Error>) -> Void) {
		provider.request(.popular) { (result) in
			completion(
				result.mapError { $0 }.flatMap { response in
					Result { try response.map([MovieModel].self) }
				}
			)
		}
	}
	
	func getRecommendations(completion: @escaping (Result<[MovieModel], Error>) -> Void) {
		provider.request(.recommendations) { (result) in
			completion(
				result.mapError { $0 }.flatMap { response in
					Result { try response.map([MovieModel].self) }
				}
			)
		}
	}
	
	func getSeries(completion: @escaping (Result<[MovieModel], Error>) -> Void) {
		provider.request(.series) { (result) in
			completion(
				result.mapError { $0 }.flatMap { response in
					Result { try response.map([MovieModel].self) }
				}
			)
		}
	}
}
