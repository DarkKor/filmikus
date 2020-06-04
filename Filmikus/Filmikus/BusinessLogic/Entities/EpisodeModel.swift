//
//  EpisodeModel.swift
//  Filmikus
//
//  Created by Андрей Козлов on 29.05.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

struct EpisodeModel: Decodable {
	let id: Int
	let title: String
	let imageUrl: ImageUrlModel
	
	enum CodingKeys: String, CodingKey {
		case id
		case title
		case imageUrl = "image_url"
	}
}
