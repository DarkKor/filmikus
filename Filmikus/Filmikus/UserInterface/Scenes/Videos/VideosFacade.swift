//
//  VideosFacade.swift
//  Filmikus
//
//  Created by Андрей Козлов on 02.06.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import Foundation

class VideosFacade {
	
	private let categoriesService: CategoriesServiceType
	private let videosService: VideosServiceType
	
	init(
		categoriesService: CategoriesServiceType = CategoriesService(),
		videosService: VideosServiceType = VideosService()
	) {
		self.categoriesService = categoriesService
		self.videosService = videosService
	}
	
	func getFunCategories(completion: @escaping (Result<[CategoryModel], Error>) -> Void) {
		categoriesService.getFunCategories { (result) in
			completion(result)
		}
	}
	
	func getFunShows(with categoryId: Int? = nil, completion: @escaping (Result<MoviesModel, Error>) -> Void) {
		var filter = FilterModel()
		filter.categoryId = categoryId
		videosService.getMovies(of: .funShow, with: filter) { (result) in
			completion(result)
		}
	}
}
