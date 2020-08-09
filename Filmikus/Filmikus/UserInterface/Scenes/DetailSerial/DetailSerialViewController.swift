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
	private let userFacade: UserFacadeType
	
	var videoState: DetailMovieVideoState {
		 if !self.userFacade.isSubscribed {
			return .needSubscription
		} else {
			return .watchMovie
		}
	}

	private lazy var collectionViewController: DetailMovieCollectionViewController = {
		let viewController = DetailMovieCollectionViewController(style: .episode)
		viewController.delegate = self
		return viewController
	}()
	
	init(
		id: Int,
		videoService: VideosServiceType = VideosService(),
		episodesService: EpisodesServiceType = EpisodesService(),
		userFacade: UserFacadeType = UserFacade()
	) {
		self.id = id
		self.videoService = videoService
		self.episodesService = episodesService
		self.userFacade = userFacade
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	deinit {
		NotificationCenter.default.removeObserver(self)
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
		
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(handleUserSubscribedNotification),
			name: .userDidSubscribe,
			object: nil
		)
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(handleUserLoggedInNotification),
			name: .userDidLogin,
			object: nil
		)
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(handleUserLogoutNotification),
			name: .userDidLogout,
			object: nil
		)
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
				let videoSection = DetailMovieVideoSection(url: videoUrl, state: self.videoState)
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
					showButtonText: "СМОТРЕТЬ СЕРИАЛ"
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
					return .video(DetailMovieVideoSection(url: videoUrl, state: self.videoState))
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
	
	private func updateContentAccess() {
		let sections: [DetailMovieSection] = collectionViewController.sections.map { section in
			switch section {
			case var .video(model):
				model.state = self.videoState
				return .video(model)
			default:
				return section
			}
		}
		collectionViewController.update(sections: sections)
	}
	
	@objc
	private func handleUserSubscribedNotification(notification: Notification) {
		updateContentAccess()
	}
	
	@objc
	private func handleUserLoggedInNotification(notification: Notification) {
		updateContentAccess()
	}
	
	@objc
	private func handleUserLogoutNotification(notification: Notification) {
		updateContentAccess()
	}
}

// MARK: - DetailMovieCollectionViewControllerDelegate

extension DetailSerialViewController: DetailMovieCollectionViewControllerDelegate {
	
	func detailMovieCollectionViewController(_ viewController: DetailMovieCollectionViewController, didSelectMovie movie: RelatedMovie) {
		updateEpisode(episodeId: movie.id)
	}
	
	func detailMovieCollectionViewControllerSelectSubscribe(_ viewController: DetailMovieCollectionViewController) {
		let subscriptionVC = SubscriptionViewController()
        subscriptionVC.onClose = {
            self.dismiss(animated: true)
        }
        present(subscriptionVC, animated: true)
	}
	
    func detailMovieCollectionViewControllerSelectShowFilm(_ viewController: DetailMovieCollectionViewController) {
        guard !userFacade.isSignedIn else {
            if userFacade.isSubscribed {
                viewController.showMovie()
            } else {
                let subscriptionVC = SubscriptionViewController()
                subscriptionVC.onClose = {
                    self.dismiss(animated: true)
                }
                present(subscriptionVC, animated: true)
            }
            return
        }
        let signInVC = SignInViewController()
        signInVC.delegate = self
        present(signInVC, animated: true)
    }
}

// MARK: - SignInViewControllerDelegate

extension DetailSerialViewController: SignInViewControllerDelegate {
	
	func signInViewControllerDidSelectClose(_ viewController: SignInViewController) {
		navigationController?.dismiss(animated: true)
	}
	
	func signInViewController(_ viewController: SignInViewController, didSignInWithPaidStatus isPaid: Bool) {
		guard !isPaid else { return }
		let subscriptionVC = SubscriptionViewController()
		subscriptionVC.onClose = {
			viewController.dismiss(animated: true)
			self.dismiss(animated: true)
		}
		viewController.present(subscriptionVC, animated: true)
	}
}
