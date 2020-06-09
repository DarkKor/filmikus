//
//  DetailFunShowViewController.swift
//  Filmikus
//
//  Created by Андрей Козлов on 05.06.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import UIKit
import WebKit

class DetailFunShowViewController: UIViewController {
	
	private let id: Int
	private let subcategoryId: Int
	
	private let videoService: VideosServiceType
	private let episodesService: EpisodesServiceType
	
	private lazy var collectionViewController: DetailFunShowCollectionViewController = {
		let viewController = DetailFunShowCollectionViewController()
		viewController.delegate = self
		return viewController
	}()
	
	private var isSignedIn: Bool {
		return StoreKitService.shared.products.first(where: { product in
			if let expiresDate = StoreKitService.shared.expirationDate(for: product.productIdentifier),
			expiresDate > Date() {
				return true
			} else {
				return false
			}
		}) != nil
	}
	
	init(
		id: Int,
		subcategoryId: Int,
		videoService: VideosServiceType = VideosService(),
		episodesService: EpisodesServiceType = EpisodesService()
	) {
		self.id = id
		self.subcategoryId = subcategoryId
		self.videoService = videoService
		self.episodesService = episodesService
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func loadView() {
		view = UIView()
		view.backgroundColor = .white
		
		addChild(collectionViewController)
		view.addSubview(collectionViewController.view)
		collectionViewController.didMove(toParent: self)
		
		collectionViewController.view.snp.makeConstraints {
			$0.edges.equalToSuperview()
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		navigationItem.largeTitleDisplayMode = .never
		loadData(with: id)
	}
	
	private func loadData(with id: Int) {
		videoService.detailEpisode(id: id) { [weak self] (result) in
			guard let self = self else { return }
			guard let detailModel = try? result.get() else { return }
			self.title = detailModel.title
			self.episodesService.getFunShowEpisodes(funShowId: self.subcategoryId) { [weak self] (result) in
				guard let self = self else { return }
				guard let episodesModel = try? result.get() else { return }
				var videoUrl = ""
				if let tvigleId = detailModel.tvigleId {
					videoUrl = "http://cloud.tvigle.ru/video/\(tvigleId)/"
				}
				let isSignedIn = true// self.isSignedIn
				let detailFunShowVideo = DetailFunShowVideoSection(
					videoUrl: videoUrl,
					isEnabled: isSignedIn
				)
				let detailFunShowInfo = DetailFunShowInfoSection(
					title: detailModel.title,
					descr: detailModel.descr,
					isEnabled: isSignedIn
				)
				let detailFunShowMore = DetailFunShowMoreSection(
					title: "Другие сериии из этого цикла",
					videos: episodesModel.items.map {
						Video(id: $0.id, title: $0.title, imageUrl: $0.imageUrl.high)
					}
				)
				self.collectionViewController.update(sections: [
					.video(detailFunShowVideo),
					.info(detailFunShowInfo),
					.more(detailFunShowMore)
				])
			}
		}
	}
}

// MARK: - DetailFunShowCollectionViewControllerDelegate

extension DetailFunShowViewController: DetailFunShowCollectionViewControllerDelegate {
	
	func detailFunShowCollectionViewController(_ viewController: DetailFunShowCollectionViewController, didSelectVideo video: Video) {
		loadData(with: video.id)
//		let detailVC = DetailFunShowViewController(id: video.id, subcategoryId: subcategoryId)
//		navigationController?.pushViewController(detailVC, animated: true)
	}
	
	func detailFunShowCollectionViewControllerSelectSignIn(_ viewController: DetailFunShowCollectionViewController) {
		tabBarController?.selectedIndex = 4
	}
	
	func detailFunShowCollectionViewControllerSelectSignUp(_ viewController: DetailFunShowCollectionViewController) {
		tabBarController?.selectedIndex = 4
	}
	
	func detailFunShowCollectionViewControllerSelectShowFilm(_ viewController: DetailFunShowCollectionViewController) {
		tabBarController?.selectedIndex = 4
	}
}
