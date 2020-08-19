//
//  WelcomeTypeModel.swift
//  Filmikus
//
//  Created by Андрей Козлов on 27.07.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import Foundation

enum WelcomeTypeModel: Int, Codable {
    // В зависимости от значения показываем разные Welcome Tour
	case firstType = 0
	case secondype = 1
	
	// Access_type=2 и более – пока не задействованы, но будут.
	
	enum CodingKeys: String, CodingKey {
		case welcomeType = "access_type"
	}
		
	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		let welcomeType = try container.decode(Int.self, forKey: .welcomeType)
		switch welcomeType {
		case 0:
			self = .firstType
		case 1:
			self = .secondype
		default:
			throw NSError()
		}
	}

}
