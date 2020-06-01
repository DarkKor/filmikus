//
//  VideoQuality.swift
//  Filmikus
//
//  Created by Андрей Козлов on 28.05.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

enum VideoQuality: String, Codable, CaseIterable {
	case sd = "sd"
	case hd = "hd"
	case fullHd = "fullhd"
}

extension VideoQuality: CustomStringConvertible {
	var description: String {
		switch self {
		case .sd:
			return "SD"
		case .hd:
			return "HD"
		case .fullHd:
			return "fullHD"
		}
	}
}
