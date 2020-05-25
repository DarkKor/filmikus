//
//  DetailVideoCategoryViewController.swift
//  Filmikus
//
//  Created by Андрей Козлов on 21.05.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import UIKit

class DetailVideoCategoryViewController: UIViewController {
	
	private let category: VideoCategory
	
	private lazy var videosCollectionViewController: VideosCollectionViewController = {
		let viewController = VideosCollectionViewController()
		viewController.delegate = self
		return viewController
	}()
	
	init(category: VideoCategory) {
		self.category = category
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func loadView() {
		view = UIView()
		view.backgroundColor = .appLightGray
		
		addChild(videosCollectionViewController)
		view.addSubview(videosCollectionViewController.view)
		videosCollectionViewController.didMove(toParent: self)
		
		videosCollectionViewController.view.snp.makeConstraints {
			$0.edges.equalToSuperview()
		}
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()

		title = category.title
		
		videosCollectionViewController.update(videos: category.videos)
    }

}

// MARK: - VideosCollectionViewControllerDelegate

extension DetailVideoCategoryViewController: VideosCollectionViewControllerDelegate {
	
	func videoCollectionViewController(_ viewController: VideosCollectionViewController, didSelectVideo video: Video) {
		print(video)
	}
}
