//
//  CountriesAPI.swift
//  Filmikus
//
//  Created by Андрей Козлов on 28.05.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import Moya

enum CountriesAPI {
	case filmCountries
	case serialCountries
}

extension CountriesAPI: TargetType {
	
	var baseURL: URL {
		URL(string: "https://api.filmikus.com/v1/countries")!
	}
	
	var path: String {
		switch self {
		case .filmCountries:
			return "/1"
		case .serialCountries:
			return "/2"
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
