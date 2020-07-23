//
//  SignInStatusModel.swift
//  Filmikus
//
//  Created by Андрей Козлов on 20.07.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import Foundation

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
