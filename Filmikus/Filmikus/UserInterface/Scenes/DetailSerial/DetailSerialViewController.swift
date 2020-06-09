//
//  DetailSerialViewController.swift
//  Filmikus
//
//  Created by Андрей Козлов on 05.06.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import UIKit
import WebKit

class DetailSerialViewController: UIViewController {
	
	private let id: Int
	
	private let videoService: VideosServiceType
	private let episodesService: EpisodesServiceType

	private lazy var collectionViewController: DetailMovieCollectionViewController = {
		let viewController = DetailMovieCollectionViewController(style: .episode)
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
		videoService: VideosServiceType = VideosService(),
		episodesService: EpisodesServiceType = EpisodesService()
	) {
		self.id = id
		self.videoService = videoService
		self.episodesService = episodesService
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func loadView() {
		view = UIView()
		view.backgroundColor = .appLightGray

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
		loadData()
	}
	
	private func loadData() {
		videoService.detailSerial(id: id) { [weak self] (result) in
			guard let self = self else { return }
			guard let detailModel = try? result.get() else { return }
			self.title = detailModel.title
			self.episodesService.getSerialEpisodes(serialId: self.id) { [weak self] (result) in
				guard let self = self else { return }
				guard let episodesModel = try? result.get() else { return }
				
				var videoUrl = ""
				if let tvigleId = detailModel.tvigleId {
					videoUrl = "http://cloud.tvigle.ru/video/\(tvigleId)/"
				}
				let isSignedIn = self.isSignedIn
				let videoSection = DetailMovieVideoSection(url: videoUrl, isEnabled: isSignedIn)
				let infoSection = DetailMovieInfoSection(
					title: detailModel.title,
					descr: detailModel.descr,
					rating: detailModel.rating,
					imageUrl: detailModel.imageUrl.high,
					categories: detailModel.categories,
					year: detailModel.year,
					duration: detailModel.duration,
					ageRating: detailModel.ageRating,
					countries: detailModel.countries,
					quality: detailModel.quality,
					directors: detailModel.directors,
					actors: detailModel.actors,
					isEnabled: isSignedIn
				)
				// При открытии сериала открывается видео первой серии поэтому приходится его выделять.
				let selectedId = episodesModel.items.first?.id ?? -1
				let relatedSection = DetailMovieRelatedSection(
					title: "",
					relatedMovies: episodesModel.items.map {
						RelatedMovie(
							id: $0.id,
							title: $0.title,
							imageUrl: $0.imageUrl.high,
							type: .serial,
							isSelected: $0.id == selectedId
						)
				})

				self.collectionViewController.update(sections: [
					.video(videoSection),
					.info(infoSection),
					.related(relatedSection)
				])
			}

		}
	}
	
	private func updateEpisode(episodeId: Int) {
		videoService.detailEpisode(id: episodeId) { [weak self] (result) in
			guard let self = self else { return }
			guard let detailModel = try? result.get() else { return }
			var videoUrl = ""
			if let tvigleId = detailModel.tvigleId {
				videoUrl = "http://cloud.tvigle.ru/video/\(tvigleId)/"
			}
			let sections = self.collectionViewController.sections
			self.collectionViewController.update(sections: sections.map {
				switch $0 {
				case .video(_):
					return .video(DetailMovieVideoSection(url: videoUrl, isEnabled: self.isSignedIn))
				case let .info(infoSection):
					return .info(infoSection)
				case var .related(relatedSection):
					relatedSection.relatedMovies = relatedSection.relatedMovies.map {
						RelatedMovie(
							id: $0.id,
							title: $0.title,
							imageUrl: $0.imageUrl,
							type: $0.type,
							isSelected: $0.id == episodeId
						)
					}
					return .related(relatedSection)
				}
			})
		}
	}
	
}

// MARK: - DetailMovieCollectionViewControllerDelegate

extension DetailSerialViewController: DetailMovieCollectionViewControllerDelegate {
	
	func detailMovieCollectionViewController(_ viewController: DetailMovieCollectionViewController, didSelectMovie movie: RelatedMovie) {
		updateEpisode(episodeId: movie.id)
	}
	
	func detailMovieCollectionViewControllerSelectSignIn(_ viewController: DetailMovieCollectionViewController) {
		tabBarController?.selectedIndex = 4
	}
	
	func detailMovieCollectionViewControllerSelectSignUp(_ viewController: DetailMovieCollectionViewController) {
		tabBarController?.selectedIndex = 4
	}
	
	func detailMovieCollectionViewControllerSelectShowFilm(_ viewController: DetailMovieCollectionViewController) {
		tabBarController?.selectedIndex = 4
	}
}
