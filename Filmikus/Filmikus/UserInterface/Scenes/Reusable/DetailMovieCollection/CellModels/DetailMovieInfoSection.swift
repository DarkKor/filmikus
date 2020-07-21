//
//  DetailMovieInfoSection.swift
//  Filmikus
//
//  Created by Андрей Козлов on 08.06.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

struct DetailMovieInfoSection {
	let title: String
	let descr: String
	let rating: Double
	let imageUrl: String
	let categories: [CategoryModel]
	let year: String
	let duration: Int
	let ageRating: String
	let countries: [CountryModel]
	let quality: String
	let directors: [DirectorModel]
	let actors: [ActorModel]
	var isEnabled: Bool
}
