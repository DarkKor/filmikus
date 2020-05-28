//
//  MovieModel.swift
//  Filmikus
//
//  Created by Андрей Козлов on 27.05.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

struct MovieModel: Codable {
	let id: Int
	let title: String
	let imageUrl: String
	let type: MovieType
	
	enum CodingKeys: String, CodingKey {
		case id
		case title
		case imageUrl = "image_url"
		case type
	}
}
