//
//  SignInSuccessModel.swift
//  Filmikus
//
//  Created by Андрей Козлов on 23.07.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

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
