//
//  DetailMovieSection.swift
//  Filmikus
//
//  Created by Андрей Козлов on 08.06.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

enum DetailMovieSection {
	case video(DetailMovieVideoSection)
	case info(DetailMovieInfoSection)
	case related(DetailMovieRelatedSection)
}

extension DetailMovieSection: Equatable {
	static func == (lhs: Self, rhs: Self) -> Bool {
		switch (lhs, rhs) {
		case (.video, .video):
			return true
		case (.info, .info):
			return true
		case (.related, .related):
			return true
		default:
			return false
		}
	}
}
