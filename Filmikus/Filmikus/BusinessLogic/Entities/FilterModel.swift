//
//  FilterModel.swift
//  Filmikus
//
//  Created by Андрей Козлов on 28.05.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import Foundation

struct FilterModel: Codable {
	var categoryId: Int? = nil
	var startDate: Int? = nil
	var endDate: Int? = nil
	var countryId: Int? = nil
	var qualities: Set<VideoQuality> = []
	var videoOrder: VideoOrder? = nil
	
	enum CodingKeys: String, CodingKey {
		case categoryId = "category_id"
		case startDate = "date_start"
		case endDate = "date_end"
		case countryId = "country_id"
		case qualities = "video_quality"
		case videoOrder = "order_by"
	}
	
	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		if let categoryId = categoryId {
			try container.encode(categoryId, forKey: .categoryId)
		}
		if let startDate = startDate {
			try container.encode(startDate, forKey: .startDate)
		}
		if let endDate = endDate {
			try container.encode(endDate, forKey: .endDate)
		}
		if let countryId = countryId {
			try container.encode(countryId, forKey: .countryId)
		}
		if !qualities.isEmpty {
			let qualitity = qualities.map { $0.rawValue }.joined(separator: "|")
			try container.encode(qualitity, forKey: .qualities)
		}
		if let videoOrder = videoOrder {
			try container.encode(videoOrder.rawValue, forKey: .videoOrder)
		}
	}
}
