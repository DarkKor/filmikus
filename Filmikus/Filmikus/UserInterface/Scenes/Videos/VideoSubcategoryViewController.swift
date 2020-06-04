//
//  VideoSubcategoryViewController.swift
//  Filmikus
//
//  Created by Андрей Козлов on 21.05.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import UIKit

class VideoSubcategoryViewController: UIViewController {
	
	private let subcategory: VideoSubcategory
	
	private let episodesServise: EpisodesServiceType = EpisodesService()
	private let videosService: VideosServiceType = VideosService()
	
	private lazy var videosCollectionViewController: VideosCollectionViewController = {
		let viewController = VideosCollectionViewController()
		viewController.delegate = self
		return viewController
	}()
	
	init(subcategory: VideoSubcategory) {
		self.subcategory = subcategory
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

		title = subcategory.title
		navigationItem.largeTitleDisplayMode = .never

		episodesServise.getFunShowEpisodes(funShowId: subcategory.id) { [weak self] (result) in
			guard let self = self else { return }
			guard let episodes = try? result.get() else { return }
			let videos = episodes.items.map { Video(id: $0.id, title: $0.title, imageUrl: $0.imageUrl.high) }
			self.videosCollectionViewController.update(videos: videos)
		}
    }

}

// MARK: - VideosCollectionViewControllerDelegate

extension VideoSubcategoryViewController: VideosCollectionViewControllerDelegate {
	
	func videoCollectionViewController(_ viewController: VideosCollectionViewController, didSelectVideo video: Video) {
		print(video)
	}
}
