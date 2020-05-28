//
//  SliderModel.swift
//  Filmikus
//
//  Created by Андрей Козлов on 27.05.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

struct SliderModel: Codable {
	let id: Int
	let type: MovieType
	let imageUrl: String
	
	enum CodingKeys: String, CodingKey {
		case id
		case type
		case imageUrl = "image_url"
	}
}
