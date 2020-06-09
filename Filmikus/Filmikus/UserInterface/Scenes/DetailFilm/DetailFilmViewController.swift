//
//  DetailFilmViewController.swift
//  Filmikus
//
//  Created by Андрей Козлов on 15.05.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import UIKit
import WebKit

class DetailFilmViewController: UIViewController {
	
	private let id: Int
	
	private let videoService: VideosServiceType

	private lazy var collectionViewController: DetailMovieCollectionViewController = {
		let viewController = DetailMovieCollectionViewController(style: .poster)
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
		videoService: VideosServiceType = VideosService()
	) {
		self.id = id
		self.videoService = videoService
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func loadView() {
		view = UIView()
		view.backgroundColor = .appDarkBlue
		
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
		videoService.detailMovie(id: id) { [weak self] (result) in
			guard let self = self else { return }
			guard let detailModel = try? result.get() else { return }
			self.title = detailModel.title
			
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
			let relatedSection = DetailMovieRelatedSection(
				title: "Похожие видео",
				relatedMovies: detailModel.similar.map {
					RelatedMovie(
						id: $0.id,
						title: $0.title,
						imageUrl: $0.imageUrl.high,
						type: .film,
						isSelected: false
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

// MARK: - DetailMovieCollectionViewControllerDelegate

extension DetailFilmViewController: DetailMovieCollectionViewControllerDelegate {
	func detailMovieCollectionViewController(_ viewController: DetailMovieCollectionViewController, didSelectMovie movie: RelatedMovie) {
		let detailVC = DetailFilmViewController(id: movie.id)
		navigationController?.pushViewController(detailVC, animated: true)
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
