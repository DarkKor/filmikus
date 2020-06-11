//
//  UserResponseModel.swift
//  Filmikus
//
//  Created by Андрей Козлов on 11.06.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

struct UserResponseModel: Decodable {
	let isSuccess: Bool
	let message: String
	let user: UserModel?
	
	enum CodingKeys: String, CodingKey {
		case isSuccess = "success"
		case message
		case user = "data"
	}
}
