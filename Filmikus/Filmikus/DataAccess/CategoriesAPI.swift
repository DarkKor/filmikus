//
//  CategoriesAPI.swift
//  Filmikus
//
//  Created by Андрей Козлов on 28.05.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import Moya

enum CategoriesAPI {
	case movies
	case series
	case fun
}

extension CategoriesAPI: TargetType {
	
	var baseURL: URL {
		URL(string: "https://api.filmikus.com/v1/categories")!
	}
	
	var path: String {
		switch self {
		case .movies:
			return "/movies"
		case .series:
			return "/series"
		case .fun:
			return "/fun"
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
