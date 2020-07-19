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
	
	init(
		provider: MoyaProvider<UsersAPI> = MoyaProvider<UsersAPI>()
	) {
		self.provider = provider
	}
	
	func register(email: String, completion: @escaping (Result<UserResponseModel, Error>) -> Void) {
        let params: [String: Any] = ["email" : email, "type" : 3]
        let privateKey = "691cc955d8e511af995ade60215672da"
        
        do {
			let jsonData = try JSONSerialization.data(withJSONObject: params, options: .fragmentsAllowed)
            let key = privateKey.data(using: .utf8)!
            let iv = AES256.randomIv()
            
            let aes = try AES256(key: key, iv: iv)
            let encrypted = try aes.encrypt(jsonData)
            let hmac = encrypted.HMAC(withKey: key, using: .SHA256)
            
            let resultData = iv + hmac + encrypted
            let base64 = resultData.base64EncodedString()
            
			provider.request(.register(userData: base64)) { (result) in
				completion(
					result.mapError { $0 }.flatMap { response in
						Result { try response.map(UserResponseModel.self) }
					}
				)
			}
        } catch {
			completion(.failure(error))
        }
	}
}
