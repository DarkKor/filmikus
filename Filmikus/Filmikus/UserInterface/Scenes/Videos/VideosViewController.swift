//
//  VideosViewController.swift
//  Filmikus
//
//  Created by Андрей Козлов on 13.05.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import UIKit

class VideosViewController: UIViewController {
	
	private let facade = VideosFacade()

	private lazy var videoCategoriesViewController: VideoCategoriesViewController = {
		let viewController = VideoCategoriesViewController()
		viewController.delegate = self
		return viewController
	}()
	
	override func loadView() {
		view = UIView()
		view.backgroundColor = .appLightGray
		
		addChild(videoCategoriesViewController)
		view.addSubview(videoCategoriesViewController.view)
		videoCategoriesViewController.didMove(toParent: self)
		
		videoCategoriesViewController.view.snp.makeConstraints {
			$0.edges.equalToSuperview()
		}
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Видео"
		
		facade.getFunCategories { [weak self] (result) in
			guard let self = self else { return }
			guard let categories = try? result.get() else { return }
			print(categories)
			let videoCategories = categories.map { VideoCategory(id: $0.id, title: $0.title, subcategories: []) }
			self.videoCategoriesViewController.update(categories: videoCategories)
			guard let videoCategory = videoCategories.first else { return }
			self.loadSubcategories(with: videoCategory.id)
		}
    }
	
	private func loadSubcategories(with categoryId: Int) {
		facade.getFunShows(with: categoryId) { [weak self] (result) in
			guard let self = self else { return }
			guard let moviesModel = try? result.get() else { return }
			let subcategories = moviesModel.items.map {
				VideoSubcategory(id: $0.id, title: $0.title, imageUrl: $0.imageUrl.high)
			}
			self.videoCategoriesViewController.update(subcategories: subcategories, by: categoryId)
		}
	}
}

// MARK: - VideoCategoriesViewControllerDelegate

extension VideosViewController: VideoCategoriesViewControllerDelegate {
	
	func videoCategoriesViewController(_ viewController: VideoCategoriesViewController, didSelectCategory category: VideoCategory) {
		loadSubcategories(with: category.id)
	}
	
	func videoCategoriesViewController(_ viewController: VideoCategoriesViewController, didSelectSubcategory subcategory: VideoSubcategory) {
		let detailVideoCategoryVC = VideoSubcategoryViewController(subcategory: subcategory)
		navigationController?.pushViewController(detailVideoCategoryVC, animated: true)
	}
}
