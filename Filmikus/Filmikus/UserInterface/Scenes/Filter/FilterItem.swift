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
	case quality(FilterContentItem)
	case sort(FilterContentItem)
	
	var content: FilterContentItem {
		get {
			switch self {
			case .genre(let filterItem):
				return filterItem
			case .country(let filterItem):
				return filterItem
			case .year(let filterItem):
				return filterItem
			case .quality(let filterItem):
				return filterItem
			case .sort(let filterItem):
				return filterItem
			}
		}
		set {
			switch self {
			case .genre:
				self = .genre(newValue)
			case .country:
				self = .country(newValue)
			case .year:
				self = .year(newValue)
			case .quality:
				self = .quality(newValue)
			case .sort:
				self = .sort(newValue)
			}
		}
	}
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
