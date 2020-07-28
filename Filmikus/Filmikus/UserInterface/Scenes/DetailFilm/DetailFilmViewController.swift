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
	private let userFacade: UserFacadeType
	
	var videoState: DetailMovieVideoState {
		if !self.userFacade.isSignedIn {
			return .needAuthentication
		} else if !self.userFacade.isSubscribed {
			return .needSubscription
		} else {
			return .watchMovie
		}
	}

	private lazy var collectionViewController: DetailMovieCollectionViewController = {
		let viewController = DetailMovieCollectionViewController(style: .poster)
		viewController.delegate = self
		return viewController
	}()
	
	init(
		id: Int,
		videoService: VideosServiceType = VideosService(),
		userFacade: UserFacadeType = UserFacade()
	) {
		self.id = id
		self.videoService = videoService
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
	
	private func loadData(with id: Int) {
		videoService.detailMovie(id: id) { [weak self] (result) in
			guard let self = self else { return }
			guard let detailModel = try? result.get() else { return }
			self.title = detailModel.title
			
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
				showButtonText: "СМОТРЕТЬ ФИЛЬМ"
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

extension DetailFilmViewController: DetailMovieCollectionViewControllerDelegate {
	func detailMovieCollectionViewController(_ viewController: DetailMovieCollectionViewController, didSelectMovie movie: RelatedMovie) {
		let detailVC = DetailFilmViewController(id: movie.id)
		navigationController?.pushViewController(detailVC, animated: true)
	}
	
	func detailMovieCollectionViewControllerSelectSignIn(_ viewController: DetailMovieCollectionViewController) {
		let signInVC = SignInViewController()
		signInVC.delegate = self
		present(signInVC, animated: true)
	}
	
	func detailMovieCollectionViewControllerSelectSignUp(_ viewController: DetailMovieCollectionViewController) {
		let signUpVC = SignUpViewController()
		signUpVC.delegate = self
		present(signUpVC, animated: true)
	}
	
	func detailMovieCollectionViewControllerSelectSubscribe(_ viewController: DetailMovieCollectionViewController) {
		present(SubscriptionViewController(), animated: true)
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

// MARK: - SignUpViewControllerDelegate

extension DetailFilmViewController: SignUpViewControllerDelegate {
	
	func signUpViewControllerDidSelectClose(_ viewController: SignUpViewController) {
		navigationController?.dismiss(animated: true)
	}
	
	func signUpViewControllerDidSignUp(_ viewController: SignUpViewController) {
		let subscriptionVC = SubscriptionViewController()
		subscriptionVC.onClose = {
			viewController.dismiss(animated: true)
			viewController.showAlert(message: "Чтобы пользоваться приложением необходимо купить подписку")
		}
		viewController.present(subscriptionVC, animated: true)
	}
}

// MARK: - SignInViewControllerDelegate

extension DetailFilmViewController: SignInViewControllerDelegate {
	
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

