//
//  DetailEpisodeModel.swift
//  Filmikus
//
//  Created by Андрей Козлов on 28.05.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//
/*

id - id объекта
	   tvigle_id
	   title - название
	   description - описание
	   series - порядковый номер серии
	   image_url - картинка
		   low - плохое качество
		   high - хорошее качество
*/
struct DetailEpisodeModel: Decodable {
	let id: Int
	let tvigleId: Int
	let title: String
	let descr: String
	let series: Int
	let imageUrl: ImageUrlModel
	
	enum CodingKeys: String, CodingKey {
		case id = "id"
		case tvigleId = "tvigle_id"
		case title = "title"
		case descr = "description"
		case imageUrl = "image_url"
		case series = "series"
	}
}
