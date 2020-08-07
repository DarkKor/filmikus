//
//  UsersService.swift
//  Filmikus
//
//  Created by Андрей Козлов on 11.06.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import Moya

protocol UsersServiceType {
	func register(email: String, completion: @escaping (Result<SignUpStatusModel, Error>) -> Void)
	func login(email: String, password: String, completion: @escaping (Result<SignInStatusModel, Error>) -> Void)
	func updateReceipt(userId: Int, receipt: String, completion: @escaping (Result<ReceiptStatusModel, Error>) -> Void)
	func accessType(completion: @escaping (Result<WelcomeTypeModel, Error>) -> Void)
}

class UsersService: UsersServiceType {
	
	private let provider: MoyaProvider<UsersAPI>
	
	init(
		provider: MoyaProvider<UsersAPI> = MoyaProvider<UsersAPI>()
	) {
		self.provider = provider
	}
	
	func register(email: String, completion: @escaping (Result<SignUpStatusModel, Error>) -> Void) {
		provider.request(.register(email: email)) { (result) in
			completion(
				result.mapError { $0 }.flatMap { response in
					Result { try response.map(SignUpStatusModel.self) }
				}
			)
		}
	}
	
	func login(email: String, password: String, completion: @escaping (Result<SignInStatusModel, Error>) -> Void) {
		provider.request(.login(email: email, password: password)) { (result) in
			completion(
				result.mapError { $0 }.flatMap { response in
					Result { try response.map(SignInStatusModel.self) }
				}
			)
		}
	}
	
	func updateReceipt(userId: Int, receipt: String, completion: @escaping (Result<ReceiptStatusModel, Error>) -> Void) {
		provider.request(.appstoreReceipt(userId: userId, receipt: receipt)) { (result) in
			completion(
				result.mapError { $0 }.flatMap { response in
					Result { try response.map(ReceiptStatusModel.self) }
				}
			)
		}
	}
	
	func accessType(completion: @escaping (Result<WelcomeTypeModel, Error>) -> Void) {
		provider.request(.accessType) { (result) in
			completion(
				result.mapError { $0 }.flatMap { response in
					Result { try response.map(WelcomeTypeModel.self) }
				}
			)
		}
	}
}
