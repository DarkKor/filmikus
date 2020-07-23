//
//  SignUpSuccessModel.swift
//  Filmikus
//
//  Created by Андрей Козлов on 23.07.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

struct SignUpSuccessModel: Decodable {
	let id: Int
	let username: String
	let password: String
	
	enum CodingKeys: String, CodingKey {
		case id = "user_id"
		case username = "user_name"
		case password = "user_pass"
	}
}
