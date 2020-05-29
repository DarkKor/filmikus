//
//  CountriesService.swift
//  Filmikus
//
//  Created by Андрей Козлов on 29.05.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import Moya

protocol CountriesServiceType {
	func getFilmCountries(completion: @escaping (Result<CountryModel, Error>) -> Void)
	func getSerialCountries(completion: @escaping (Result<CountryModel, Error>) -> Void)
}

class CountriesService: CountriesServiceType {
	
	private let provider: MoyaProvider<CountriesAPI>
	
	init(provider: MoyaProvider<CountriesAPI> = MoyaProvider<CountriesAPI>()) {
		self.provider = provider
	}
	
	func getFilmCountries(completion: @escaping (Result<CountryModel, Error>) -> Void) {
		provider.request(.filmCountries) { (result) in
			completion(
				result.mapError { $0 }.flatMap { response in
					Result { try response.map(CountryModel.self) }
				}
			)
		}
	}
	
	func getSerialCountries(completion: @escaping (Result<CountryModel, Error>) -> Void) {
		provider.request(.serialCountries) { (result) in
			completion(
				result.mapError { $0 }.flatMap { response in
					Result { try response.map(CountryModel.self) }
				}
			)
		}
	}
}
