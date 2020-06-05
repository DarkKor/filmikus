//
//  MovieModel.swift
//  Filmikus
//
//  Created by Андрей Козлов on 27.05.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

struct MovieModel: Decodable {
	let id: Int
	let title: String
	let imageUrl: String?
	let type: MovieType
	
	enum CodingKeys: String, CodingKey {
		case id
		case title
		case imageUrl = "image_url"
		case type
	}
	
	init(
		id: Int,
		title: String,
		imageUrl: String?,
		type: MovieType
	) {
		self.id = id
		self.title = title
		self.imageUrl = imageUrl
		self.type = type
	}
	
	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		id = try container.decode(Int.self, forKey: .id)
		title = try container.decode(String.self, forKey: .title)
		if let url = try? container.decode(String.self, forKey: .imageUrl) {
			imageUrl = url
		} else {
			imageUrl = try? container.decodeIfPresent(ImageUrlModel.self, forKey: .imageUrl)?.high
		}
		type = try container.decode(MovieType.self, forKey: .type)
	}
}
