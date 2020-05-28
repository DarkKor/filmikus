//
//  MoviesModel.swift
//  Filmikus
//
//  Created by Андрей Козлов on 28.05.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

struct MoviesModel: Decodable {
	let items: [MovieItem]
	
	enum CodingKeys: String, CodingKey {
		case items = "items"
	}
	
	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		items = try container.decode([MovieItem].self, forKey: CodingKeys.items)
	}
}
