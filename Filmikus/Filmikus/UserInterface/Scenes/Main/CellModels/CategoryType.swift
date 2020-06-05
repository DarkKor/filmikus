//
//  CategoryType.swift
//  Filmikus
//
//  Created by Андрей Козлов on 05.06.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

enum CategoryType {
	case popular
	case recommendations
	case series
	case funShow
}

extension CategoryType: CustomStringConvertible {
	var description: String {
		switch self {
		case .popular:
			return "Популярное"
		case .recommendations:
			return "Рекомендуем"
		case .series:
			return "Сериалы"
		case .funShow:
			return "Развлекательное видео"
		}
	}
}
