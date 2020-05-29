//
//  EpisodesService.swift
//  Filmikus
//
//  Created by Андрей Козлов on 29.05.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import Moya

protocol EpisodesServiceType {
	func getSerialEpisodes(serialId: Int, completion: @escaping (Result<[EpisodeModel], Error>) -> Void)
	func getFunShowEpisodes(funShowId: Int, completion: @escaping (Result<[EpisodeModel], Error>) -> Void)
}

class EpisodesService: EpisodesServiceType {
	
	private let provider: MoyaProvider<EpisodesAPI>
	
	init(provider: MoyaProvider<EpisodesAPI> = MoyaProvider<EpisodesAPI>()) {
		self.provider = provider
	}
	
	func getSerialEpisodes(serialId: Int, completion: @escaping (Result<[EpisodeModel], Error>) -> Void) {
		provider.request(.serial(id: serialId)) { (result) in
			completion(
				result.mapError { $0 }.flatMap { response in
					Result { try response.map([EpisodeModel].self) }
				}
			)
		}
	}
	
	func getFunShowEpisodes(funShowId: Int, completion: @escaping (Result<[EpisodeModel], Error>) -> Void) {
		provider.request(.funShow(id: funShowId)) { (result) in
			completion(
				result.mapError { $0 }.flatMap { response in
					Result { try response.map([EpisodeModel].self) }
				}
			)
		}
	}
}
