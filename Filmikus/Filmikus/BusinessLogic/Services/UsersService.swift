//
//  UsersService.swift
//  Filmikus
//
//  Created by Андрей Козлов on 11.06.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import Moya

protocol UsersServiceType {
	func register(email: String, completion: @escaping (Result<UserResponseModel, Error>) -> Void)
}

class UsersService: UsersServiceType {
	
	private let provider: MoyaProvider<UsersAPI>
	
	init(provider: MoyaProvider<UsersAPI> = MoyaProvider<UsersAPI>()) {
		self.provider = provider
	}
	
	func register(email: String, completion: @escaping (Result<UserResponseModel, Error>) -> Void) {
		provider.request(.register(email: email)) { (result) in
			completion(
				result.mapError { $0 }.flatMap { response in
					Result { try response.map(UserResponseModel.self) }
				}
			)
		}
	}
}
