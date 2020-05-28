//
//  VideosAPI.swift
//  Filmikus
//
//  Created by Андрей Козлов on 28.05.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import Moya

enum VideosAPI {
	case filteredList(type: MovieType, filter: FilterModel)
	case search(query: String)
	case item(type: MovieType, id: Int)
	case episode(id: Int)
}

extension VideosAPI: TargetType {
	
	var baseURL: URL {
		URL(string: "https://api.filmikus.com/v1/videos")!
	}
	
	var path: String {
		// /v1/videos/{type(1,2,3)}{?category_id}{?date_start}{?date_end}{?country_id}{?video_quality=sd|hd|fullhd}{?order_by(popular,new)}
		switch self {
		case let .filteredList(type, _):
			return "/\(type.rawValue)"
		case .search:
			return "/search"
		case let .item(type, id):
			return "/\(type.rawValue)/\(id)"
		case let .episode(id):
			return "/episode/\(id)"
		}
	}
	
	var method: Method {
		.get
	}
	
	var sampleData: Data {
		Data()
	}
	
	var task: Task {
		func jsonFrom(filter: FilterModel) -> [String: Any] {
			let encoder = JSONEncoder()
			guard let data = try? encoder.encode(filter) else { return [:] }
			guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else { return [:] }
			return json
		}
		switch self {
		case .filteredList(_, let filter):
			return .requestParameters(parameters: jsonFrom(filter: filter), encoding: URLEncoding.queryString)
		case .search(let query):
			return .requestParameters(parameters: ["query": query], encoding: URLEncoding.queryString)
		case .item:
			return .requestPlain
		case .episode:
			return .requestPlain
		}
	}
	
	var headers: [String : String]? {
		nil
	}
}
