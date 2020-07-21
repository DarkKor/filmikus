//
//  SignInStatusModel.swift
//  Filmikus
//
//  Created by Андрей Козлов on 20.07.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import Foundation

//	paid - оплата (1-оплачено, 0-неоплачено)

enum SignInStatusModel: Decodable {
	case success(SignInSuccessModel)
	case failure(SignInFailureModel)
	
	enum CodingKeys: String, CodingKey {
		case status = "auth_status"
	}
	
	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		
		let status = try container.decode(String.self, forKey: .status)
		switch status {
		case "success":
			let model = try SignInSuccessModel(from: decoder)
			self = .success(model)
		case "fail":
			let model = try SignInFailureModel(from: decoder)
			self = .failure(model)
		default:
			throw NSError()
		}
	}
}

struct SignInSuccessModel: Codable {
	let userId: Int
	let userType: Int
	let isPaid: Bool
	
	enum CodingKeys: String, CodingKey {
		case userId = "user_id"
		case userType = "type"
		case isPaid = "paid"
	}
	
	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		
		userId = try container.decode(Int.self, forKey: .userId)
		userType = try container.decode(Int.self, forKey: .userType)
		let paid = try container.decode(Int.self, forKey: .userType)
		isPaid = paid == 1
	}
}

struct SignInFailureModel: Codable {
	let errorDescription: String
	let errorCode: String
	
	enum CodingKeys: String, CodingKey {
		case errorDescription = "err_desc"
		case errorCode = "err_code"
	}
}
