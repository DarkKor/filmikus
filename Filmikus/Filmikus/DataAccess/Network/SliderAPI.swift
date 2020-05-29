//
//  SliderAPI.swift
//  Filmikus
//
//  Created by Андрей Козлов on 28.05.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import Moya

enum SliderAPI {
	case sliders(type: MovieType)
}

extension SliderAPI: TargetType {
	
	var baseURL: URL {
		URL(string: "https://api.filmikus.com/v1/slider")!
	}
	
	var path: String {
		switch self {
		case let .sliders(type):
			return "/\(type.rawValue)"
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
