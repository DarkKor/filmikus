//
//  SignUpStatusModel.swift
//  Filmikus
//
//  Created by Андрей Козлов on 20.07.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import Foundation

enum SignUpStatusModel: Decodable {
	case success(SignUpSuccessModel)
	case failure(SignUpFailureModel)
	
	enum CodingKeys: String, CodingKey {
		case status = "reg_status"
	}
	
	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		
		let status = try container.decode(String.self, forKey: .status)
		switch status {
		case "success":
			let model = try SignUpSuccessModel(from: decoder)
			self = .success(model)
		case "fail":
			let model = try SignUpFailureModel(from: decoder)
			self = .failure(model)
		default:
			throw NSError()
		}
	}
}
