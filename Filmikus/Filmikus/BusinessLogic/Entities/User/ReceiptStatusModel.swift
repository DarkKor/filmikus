//
//  ReceiptStatusModel.swift
//  Filmikus
//
//  Created by Андрей Козлов on 20.07.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import Foundation

struct ReceiptStatusModel: Decodable {
	let userId: Int
	let expirationDate: Date?
	
	enum CodingKeys: String, CodingKey {
		case userId = "user_id"
		case expirationDate = "exp_date"
	}
	
	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		
		userId = try container.decode(Int.self, forKey: .userId)
		let date = try container.decode(String.self, forKey: .expirationDate)
		let formatter = DateFormatter()
		formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
		expirationDate = formatter.date(from: date)
	}
}
