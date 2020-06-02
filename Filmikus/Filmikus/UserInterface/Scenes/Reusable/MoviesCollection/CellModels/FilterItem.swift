//
//  FilterItem.swift
//  Filmikus
//
//  Created by Андрей Козлов on 18.05.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

enum FilterItem {
	case genre(FilterContentItem)
	case country(FilterContentItem)
	case year(FilterContentItem)
	case quality(FilterQualityContentItem)
	case sort(FilterContentItem)
}

extension FilterItem: Equatable {
	
	static func == (lhs: FilterItem, rhs: FilterItem) -> Bool {
		switch (lhs, rhs) {
		case (.genre, .genre):
			return true
		case (.country, .country):
			return true
		case (.year, .year):
			return true
		case (.quality, .quality):
			return true
		case (.sort, .sort):
			return true
		default:
			return false
		}
	}
}
