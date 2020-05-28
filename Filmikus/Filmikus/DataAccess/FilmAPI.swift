//
//  FilmAPI.swift
//  Filmikus
//
//  Created by Андрей Козлов on 25.05.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import Moya

enum FilmAPI {
	static let apiKey = ""
	case films
}

extension FilmAPI: TargetType {
	
	var baseURL: URL {
		URL(string: "https://api.filmikus.com")!
	}
	
	var path: String {
		switch self {
		case .films:
			return "/films"
		}
	}
	
	var method: Method {
		switch self {
		case .films:
			return .get
		}
	}
	
	var sampleData: Data {
		switch self {
		case .films:
			return "Test films".data(using: .utf8)!
		}
	}
	
	var task: Task {
		switch self {
		case .films:
			let params = [
                "APPID": Self.apiKey,
                "id": ""
            ]
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
		}
	}
	
	var headers: [String : String]? {
		["Content-type": "application/json"]
	}
}
