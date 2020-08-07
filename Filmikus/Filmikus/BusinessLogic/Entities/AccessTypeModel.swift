//
//  AccessTypeModel.swift
//  Filmikus
//
//  Created by Андрей Козлов on 27.07.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import Foundation

enum WelcomeTypeModel: Int, Codable {
    // В зависимости от значения показываем разные Welcome Tour
	case firstWelcomeType = 0
	case secondWelcomeType = 1
	
	// Access_type=2 и более – пока не задействованы, но будут.
	
	enum CodingKeys: String, CodingKey {
		case welcomeType = "welcome_type"
	}
		
	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		let accessType = try container.decode(Int.self, forKey: .welcomeType)
		switch accessType {
		case 0:
			self = .firstWelcomeType
		case 1:
			self = .secondWelcomeType
		default:
			throw NSError()
		}
	}

}
