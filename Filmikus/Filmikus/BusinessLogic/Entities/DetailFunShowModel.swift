//
//  DetailFunShowModel.swift
//  Filmikus
//
//  Created by Андрей Козлов on 28.05.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

struct DetailFunShowModel: Decodable {
	let id: Int
	let title: String
	let descr: String
	let categories: [CategoryModel]
	let imageUrl: ImageUrlModel
	
	enum CodingKeys: String, CodingKey {
		case id = "id"
		case title = "title"
		case descr = "description"
		case imageUrl = "image_url"
		case categories = "category"
	}
}
