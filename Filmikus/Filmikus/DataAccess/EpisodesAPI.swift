//
//  EpisodesAPI.swift
//  Filmikus
//
//  Created by Андрей Козлов on 28.05.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import Moya

enum EpisodesAPI {
	case serial(id: Int)
	case funShow(id: Int)
}

extension EpisodesAPI: TargetType {
	
	var baseURL: URL {
		URL(string: "https://api.filmikus.com/v1/episodes")!
	}
	
	var path: String {
		switch self {
		case let .serial(id):
			return "/2/\(id)"
		case let .funShow(id):
			return "/3/\(id)"
		}
	}
	
	var method: Method {
		.get
	}
	
	var sampleData: Data {
		Data()
	}
	
	var task: Task {
		.requestPlain
	}
	
	var headers: [String : String]? {
		nil
	}
}
