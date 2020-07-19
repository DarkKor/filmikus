//
//  UserResponseModel.swift
//  Filmikus
//
//  Created by Андрей Козлов on 11.06.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

struct UserResponseModel: Decodable {
	let isSuccess: Bool
	let user: UserModel?
	let message: String
	let code: String
	
	enum CodingKeys: String, CodingKey {
		case isSuccess = "reg_status"
		case user = "data"
		case message = "err_desc"
		case code = "err_code"
	}
	
	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		
		// Сервер почему-то присылает флаг текстом. Возможно планируют присылать больше двух статусов.
		if let isSuccess = try? container.decode(Bool.self, forKey: CodingKeys.isSuccess) {
			self.isSuccess = isSuccess
		} else {
			let isSuccess = try container.decode(String.self, forKey: CodingKeys.isSuccess)
			self.isSuccess = isSuccess == "success"
		}
		message = try container.decodeIfPresent(String.self, forKey: CodingKeys.message) ?? ""
		code = try container.decodeIfPresent(String.self, forKey: CodingKeys.code) ?? ""
		user = try? UserModel(from: decoder)
	}
}
