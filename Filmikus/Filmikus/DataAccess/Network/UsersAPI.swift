//
//  UsersAPI.swift
//  Filmikus
//
//  Created by Андрей Козлов on 11.06.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import Moya
import CommonCrypto

enum UsersAPI {
	case register(userData: String)
}

extension UsersAPI: TargetType {
	
	var privateKey: String {
		"6899af69bbc6c19332fb533969d540c4"
	}
	
	var baseURL: URL {
		URL(string: "https://api.filmikus.com/v1/users")!
	}
	
	var path: String {
		switch self {
		case .register:
			return ""
		}
	}
	
	var method: Method {
		switch self {
		case .register:
			return .post
		}
	}
	
	var sampleData: Data {
		Data()
	}
	
	var task: Task {
		switch self {
		case let .register(userData):
			return .requestParameters(
				parameters: [
					"data": userData
				],
				encoding: JSONEncoding.default
			)
		}
	}
	
	var headers: [String : String]? {
		switch self {
		case .register:
			return [
				"Content-Type": "application/json",
				"X-Api-Key": privateKey
			]
		}
	}
}
