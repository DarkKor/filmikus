//
//  MainAPI.swift
//  Filmikus
//
//  Created by Андрей Козлов on 27.05.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import Moya

enum MainApi {
	case slider
	case popular
	case recommendations
	case series
}

extension MainApi: TargetType {
	
	var baseURL: URL {
		URL(string: "https://api.filmikus.com/v1/main")!
	}
	
	var path: String {
		switch self {
		case .slider:
			return "/slider"
		case .popular:
			return "/popular"
		case .recommendations:
			return "/recommendations"
		case .series:
			return "/series"
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
