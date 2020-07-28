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
	case register(email: String)
	case login(email: String, password: String)
	case appstoreReceipt(userId: Int, receipt: String)
	case accessType
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
		case .login:
			return "/login"
		case .appstoreReceipt:
			return "/appstore-receipt"
		case .accessType:
			return "/access-type"
		}
	}
	
	var method: Method {
		.post
	}
	
	var sampleData: Data {
		Data()
	}
	
	var task: Task {
		var json: [String: Any] = ["type": 3]
		switch self {
		case let .register(email):
			json["email"] = email
		case let .login(email, password):
			json["email"] = email
			json["pass"] = password
		case let .appstoreReceipt(userId, receipt):
			json["user_id"] = userId
			json["appstorereceipt"] = receipt
		case .accessType:
			return .requestPlain
		}
		let encryptedJson = try? encrypt(json: json)
		return .requestParameters(
			parameters: [
				"data": encryptedJson ?? ""
			],
			encoding: JSONEncoding.default
		)
	}
	
	var headers: [String : String]? {
		[
			"Content-Type": "application/json",
			"X-Api-Key": privateKey
		]
	}
	
	private func encrypt(json: [String: Any]) throws -> String {
        let privateKey = "691cc955d8e511af995ade60215672da"
		let jsonData = try JSONSerialization.data(withJSONObject: json, options: .fragmentsAllowed)
		let key = privateKey.data(using: .utf8)!
		let iv = AES256.randomIv()
		
		let aes = try AES256(key: key, iv: iv)
		let encrypted = try aes.encrypt(jsonData)
		let hmac = encrypted.HMAC(withKey: key, using: .SHA256)
		
		let resultData = iv + hmac + encrypted
		return resultData.base64EncodedString()
	}
}
