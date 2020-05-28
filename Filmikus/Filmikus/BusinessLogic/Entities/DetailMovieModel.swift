//
//  DetailMovieModel.swift
//  Filmikus
//
//  Created by Андрей Козлов on 28.05.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

struct DetailMovieModel: Decodable {
	let id: Int
	let tvigleId: Int
	let title: String
	let descr: String
	let rating: Double
	let imageUrl: ImageUrlModel
	let categories: [CategoryModel]
	let year: Int
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
}
