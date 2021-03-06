//
//  DetailFunShowViewController.swift
//  Filmikus
//
//  Created by Андрей Козлов on 05.06.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import UIKit
import WebKit

class DetailFunShowViewController: ViewController {
	
	private let id: Int
	private let subcategoryId: Int
	
	private let videoService: VideosServiceType
	private let episodesService: EpisodesServiceType
	private let userFacade: UserFacadeType
	
    var videoState: DetailMovieVideoState {
		userFacade.isSubscribed ? .watchMovie : .needSubscription
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
		self.showActivityIndicator()
		videoService.detailEpisode(id: id) { [weak self] (result) in
			guard let self = self else { return }
			self.hideActivityIndicator()
			switch result {
			case .failure:
				self.showNetworkErrorAlert()
			case .success(let detailModel):
				self.title = detailModel.title
				self.showActivityIndicator()
				self.episodesService.getFunShowEpisodes(funShowId: self.subcategoryId) { [weak self] (result) in
					guard let self = self else { return }
					self.hideActivityIndicator()
					switch result {
					case .failure:
						self.showNetworkErrorAlert()
					case .success(let episodesModel):
						var videoUrl = ""
						if let tvigleId = detailModel.tvigleId {
							videoUrl = "http://cloud.tvigle.ru/video/\(tvigleId)/?partnerId=10458"
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
	
    func detailFunShowCollectionViewControllerSelectSubscribe(_ viewController: DetailFunShowCollectionViewController) {
        let payViewType: WelcomeTypeModel = userFacade.payViewType ?? .firstType
        switch payViewType {
        case .firstType:
            let payVC = FirstTourPayViewController(state: .regular)
            payVC.onClose = {
                self.dismiss(animated: true)
            }
            present(payVC, animated: true)
        case .secondype:
            let payVC = SecondTourPayViewController(state: .regular)
            payVC.onClose = {
                self.dismiss(animated: true)
            }
            present(payVC, animated: true)
        }
    }
	
	func detailFunShowCollectionViewControllerSelectShowFilm(_ viewController: DetailFunShowCollectionViewController) {
		if userFacade.isSubscribed {
			viewController.showMovie()
		} else {
			if userFacade.isSignedIn {
				let payViewType: WelcomeTypeModel = userFacade.payViewType ?? .firstType
				switch payViewType {
				case .firstType:
					let payVC = FirstTourPayViewController(state: .regular)
					payVC.onClose = {
						self.dismiss(animated: true)
					}
					present(payVC, animated: true)
				case .secondype:
					let payVC = SecondTourPayViewController(state: .regular)
					payVC.onClose = {
						self.dismiss(animated: true)
					}
					present(payVC, animated: true)
				}
			} else {
				let signInVC = SignInViewController()
				signInVC.delegate = self
				present(signInVC, animated: true)
			}
		}
	}
}

// MARK: - SignInViewControllerDelegate

extension DetailFunShowViewController: SignInViewControllerDelegate {
	
	func signInViewControllerDidSelectClose(_ viewController: SignInViewController) {
		navigationController?.dismiss(animated: true)
	}
	
    func signInViewController(_ viewController: SignInViewController, didSignInWithPaidStatus isPaid: Bool) {
        guard !isPaid else {
            dismiss(animated: true)
            return
        }
        let payViewType: WelcomeTypeModel = userFacade.payViewType ?? .firstType
        switch payViewType {
        case .firstType:
            let payVC = FirstTourPayViewController(state: .regular)
            payVC.onClose = {
                self.dismiss(animated: true)
                viewController.dismiss(animated: true)
            }
            viewController.present(payVC, animated: true)
        case .secondype:
            let payVC = SecondTourPayViewController(state: .regular)
            payVC.onClose = {
                self.dismiss(animated: true)
                viewController.dismiss(animated: true)
            }
            viewController.present(payVC, animated: true)
        }
    }
}
