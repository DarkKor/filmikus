//
//  UserModel.swift
//  Filmikus
//
//  Created by Андрей Козлов on 11.06.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

struct UserModel: Codable {
	let id: Int
	let username: String
	let password: String
	let isPaid: Bool
	
	enum CodingKeys: String, CodingKey {
		case id = "user_id"
		case username = "user_name"
		case password = "user_pass"
		case isPaid = "is_paid"
	}
}
