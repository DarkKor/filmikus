//
//  VideoOrder.swift
//  Filmikus
//
//  Created by Андрей Козлов on 28.05.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

enum VideoOrder: String, Codable, CaseIterable {
	case popular = "popular"
	case new = "new"
}

extension VideoOrder: CustomStringConvertible {
	var description: String {
		switch self {
		case .popular:
			return "По популярности"
		case .new:
			return "По новизне"
		}
	}
}
