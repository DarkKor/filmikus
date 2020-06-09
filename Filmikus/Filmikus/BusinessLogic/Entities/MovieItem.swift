//
//  MovieItem.swift
//  Filmikus
//
//  Created by Андрей Козлов on 28.05.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import Foundation

struct MovieItem: Decodable {
	let id: Int
	let title: String
	let imageUrl: ImageUrlModel
	
	enum CodingKeys: String, CodingKey {
		case id
		case title
		case imageUrl = "image_url"
	}
	
	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		// Сервер почему-то присылает айди строкой. Приходится парсить вручную.
		if let id = try? container.decode(Int.self, forKey: CodingKeys.id) {
			self.id = id
		} else {
			let strId = try container.decode(String.self, forKey: CodingKeys.id)
			guard let id = Int(strId) else {
				throw NSError()
			}
			self.id = id
		}
		self.title = try container.decodeIfPresent(String.self, forKey: CodingKeys.title) ?? ""
		self.imageUrl = try container.decodeIfPresent(ImageUrlModel.self, forKey: CodingKeys.imageUrl) ?? ImageUrlModel(low: "", high: "")
	}
}
