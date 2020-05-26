//
//  VideosViewController.swift
//  Filmikus
//
//  Created by Андрей Козлов on 13.05.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import UIKit

class VideosViewController: UIViewController {

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
		
		let videoCategories = [
			VideoCategory(
				imageUrl: "https://filmikus.com/images/3/1/middle/img.jpg",
				title: "Тест драйв",
				videos: [
					Video(imageUrl: "https://filmikus.com/images/3/1/1/middle/img.jpg", title: "Peugeot 308 SW"),
					Video(imageUrl: "https://filmikus.com/images/3/1/3/middle/img.jpg", title: "Saab XWD"),
					Video(imageUrl: "https://filmikus.com/images/3/1/4/middle/img.jpg", title: "Honda"),
					Video(imageUrl: "https://filmikus.com/images/3/1/6/middle/img.jpg", title: "Chevrolet"),
					Video(imageUrl: "https://filmikus.com/images/3/1/13/middle/img.jpg", title: "Renault"),
					Video(imageUrl: "https://filmikus.com/images/3/1/14/middle/img.jpg", title: "Mercedes"),
					Video(imageUrl: "https://filmikus.com/images/3/1/17/middle/img.jpg", title: "Audi"),
					Video(imageUrl: "https://filmikus.com/images/3/1/18/middle/img.jpg", title: "Ford"),
					Video(imageUrl: "https://filmikus.com/images/3/1/21/middle/img.jpg", title: "Skoda"),
					Video(imageUrl: "https://filmikus.com/images/3/1/38/middle/img.jpg", title: "Mini Cooper"),
					Video(imageUrl: "https://filmikus.com/images/3/1/59/middle/img.jpg", title: "Citroen"),
					Video(imageUrl: "https://filmikus.com/images/3/1/57/middle/img.jpg", title: "Mitsubishi"),
					Video(imageUrl: "https://filmikus.com/images/3/1/54/middle/img.jpg", title: "Mazda")
				]
			),
			VideoCategory(
				imageUrl: "https://filmikus.com/images/3/6/middle/img.jpg",
				title: "Мода",
				videos: []
			),
			VideoCategory(
				imageUrl: "https://filmikus.com/images/3/7/middle/img.jpg",
				title: "Стань красивой",
				videos: []
			),
			VideoCategory(
				imageUrl: "https://filmikus.com/images/3/8/middle/img.jpg",
				title: "Простые советы",
				videos: []
			),
			VideoCategory(
				imageUrl: "https://filmikus.com/images/3/9/middle/img.jpg",
				title: "Мода S",
				videos: []
			),
			VideoCategory(
				imageUrl: "https://filmikus.com/images/3/10/middle/img.jpg",
				title: "Star fashion",
				videos: []
			)
		]
		
		videoCategoriesViewController.update(categories: videoCategories)
    }
	
	@objc
	private func segmentControlChanged(sender: UnderlinedSegmentControl) {
		let index = sender.selectedIndex
		print(sender.buttons[index].title(for: .normal)!)
	}
}

// MARK: - VideoCategoriesViewControllerDelegate

extension VideosViewController: VideoCategoriesViewControllerDelegate {
	
	func videoCategoriesViewController(_ viewController: VideoCategoriesViewController, didSelectCategory category: VideoCategory) {
		let detailVideoCategoryVC = DetailVideoCategoryViewController(category: category)
		navigationController?.pushViewController(detailVideoCategoryVC, animated: true)
	}
}
