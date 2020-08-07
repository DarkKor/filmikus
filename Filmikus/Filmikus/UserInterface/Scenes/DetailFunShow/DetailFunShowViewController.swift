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
	private let userFacade: UserFacadeType
	
    var videoState: DetailMovieVideoState {
        if !self.userFacade.isSubscribed {
            return .needSubscription
        } else {
            return .watchMovie
        }
    }
	
	private lazy var collectionViewController: DetailFunShowCollectionViewController = {
		let viewController = DetailFunShowCollectionViewController()
		viewController.delegate = self
		return viewController
	}()
	
	init(
		id: Int,
		subcategoryId: Int,
		videoService: VideosServiceType = VideosService(),
		episodesService: EpisodesServiceType = EpisodesService(),
		userFacade: UserFacadeType = UserFacade()
	) {
		self.id = id
		self.subcategoryId = subcategoryId
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
				let detailFunShowVideo = DetailFunShowVideoSection(
					videoUrl: videoUrl,
					state: self.videoState
				)
				let detailFunShowInfo = DetailFunShowInfoSection(
					title: detailModel.title,
					descr: detailModel.descr
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
	
	private func updateContentAccess() {
		let sections: [DetailFunShowSection] = collectionViewController.sections.map { section in
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

// MARK: - DetailFunShowCollectionViewControllerDelegate

extension DetailFunShowViewController: DetailFunShowCollectionViewControllerDelegate {
	
	func detailFunShowCollectionViewController(_ viewController: DetailFunShowCollectionViewController, didSelectVideo video: Video) {
		loadData(with: video.id)
	}
	
	func detailFunShowCollectionViewControllerSelectSignIn(_ viewController: DetailFunShowCollectionViewController) {
		let signInVC = SignInViewController()
		signInVC.delegate = self
		present(signInVC, animated: true)
	}
	
	func detailFunShowCollectionViewControllerSelectSignUp(_ viewController: DetailFunShowCollectionViewController) {
		let signUpVC = SignUpViewController()
		signUpVC.delegate = self
		navigationController?.present(signUpVC, animated: true)
	}
	
	func detailFunShowCollectionViewControllerSelectSubscribe(_ viewController: DetailFunShowCollectionViewController) {
		let subscriptionVC = SubscriptionViewController()
        subscriptionVC.onClose = {
            self.dismiss(animated: true)
        }
        present(subscriptionVC, animated: true)
	}
	
	func detailFunShowCollectionViewControllerSelectShowFilm(_ viewController: DetailFunShowCollectionViewController) {
		let signInVC = SignInViewController()
		signInVC.delegate = self
		present(signInVC, animated: true)
	}
}

// MARK: - SignUpViewControllerDelegate

extension DetailFunShowViewController: SignUpViewControllerDelegate {
	
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

extension DetailFunShowViewController: SignInViewControllerDelegate {
	
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
