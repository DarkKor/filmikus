//
//  SliderService.swift
//  Filmikus
//
//  Created by Андрей Козлов on 29.05.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import Moya

protocol SliderServiceType {
	func getSliders(of type: MovieType, completion: @escaping (Result<SliderModel, Error>) -> Void)
}

class SliderService: SliderServiceType {
	
	private let provider: MoyaProvider<SliderAPI>
	
	init(provider: MoyaProvider<SliderAPI> = MoyaProvider<SliderAPI>()) {
		self.provider = provider
	}
	
	func getSliders(of type: MovieType, completion: @escaping (Result<SliderModel, Error>) -> Void) {
		provider.request(.sliders(type: type)) { (result) in
			completion(
				result.mapError { $0 }.flatMap { response in
					Result { try response.map(SliderModel.self) }
				}
			)
		}
	}
}
