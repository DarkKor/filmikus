//
//  DetailMovieModel.swift
//  Filmikus
//
//  Created by Андрей Козлов on 28.05.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import Foundation

struct DetailMovieModel: Decodable {
	let id: Int
	let tvigleId: Int?
	let title: String
	let descr: String
	let rating: Double
	let imageUrl: ImageUrlModel
	let categories: [CategoryModel]
	let year: String
	let duration: Int
	let ageRating: String
	let countries: [CountryModel]
	let quality: String
	let directors: [DirectorModel]
	let actors: [ActorModel]
	let similar: [MovieItem]
	
	enum CodingKeys: String, CodingKey {
		case id = "id"
		case tvigleId = "tvigle_id"
		case title = "title"
		case descr = "description"
		case rating = "rating"
		case imageUrl = "image_url"
		case categories = "category"
		case year = "year"
		case duration = "duration"
		case ageRating = "age_rating"
		case countries = "country"
		case quality = "quality"
		case directors = "director"
		case actors = "actor"
		case similar = "similar"
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
		tvigleId = try container.decodeIfPresent(Int.self, forKey: CodingKeys.tvigleId)
		title = try container.decodeIfPresent(String.self, forKey: CodingKeys.title) ?? ""
		descr = try container.decodeIfPresent(String.self, forKey: CodingKeys.descr) ?? ""
		rating = try container.decodeIfPresent(Double.self, forKey: CodingKeys.rating) ?? 0.0
		imageUrl = try container.decodeIfPresent(ImageUrlModel.self, forKey: CodingKeys.imageUrl) ?? ImageUrlModel(low: "", high: "")
		categories = try container.decodeIfPresent([CategoryModel].self, forKey: CodingKeys.categories) ?? []
		year = try container.decodeIfPresent(String.self, forKey: CodingKeys.year) ?? ""
		duration = try container.decodeIfPresent(Int.self, forKey: CodingKeys.duration) ?? 0
		ageRating = try container.decodeIfPresent(String.self, forKey: CodingKeys.ageRating) ?? ""
		countries = try container.decodeIfPresent([CountryModel].self, forKey: CodingKeys.countries) ?? []
		quality = try container.decodeIfPresent(String.self, forKey: CodingKeys.quality) ?? ""
		directors = try container.decodeIfPresent([DirectorModel].self, forKey: CodingKeys.directors) ?? []
		actors = try container.decodeIfPresent([ActorModel].self, forKey: CodingKeys.actors) ?? []
		similar = try container.decodeIfPresent([MovieItem].self, forKey: CodingKeys.similar) ?? []
	}
}
