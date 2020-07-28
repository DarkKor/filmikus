//
//  AccessTypeModel.swift
//  Filmikus
//
//  Created by Андрей Козлов on 27.07.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import Foundation

enum AccessTypeModel: Int, Codable {
	/// Если доступ не оплачен, то юзеру не доступен даже просмотр контента.
	/// Он может видеть только страничку с оформления заказа / продления доступа
	case onlyAuthorization = 0
	
	/// Если доступ не оплачен, то юзеру доступен список контента на просмотр,
	/// но при попытке  просмотра – показываем страничку с оформлением заказа / продлением доступа
	case allAppWithoutContent = 1
	
	// Access_type=2 и более – пока не задействованы, но будут .
	
	enum CodingKeys: String, CodingKey {
		case accessType = "access_type"
	}
		
	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		let accessType = try container.decode(Int.self, forKey: .accessType)
		switch accessType {
		case 0:
			self = .onlyAuthorization
		case 1:
			self = .allAppWithoutContent
		default:
			throw NSError()
		}
	}

}
