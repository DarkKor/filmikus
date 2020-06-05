//
//  DetailMovieViewController.swift
//  Filmikus
//
//  Created by Андрей Козлов on 15.05.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import UIKit
import WebKit

class DetailMovieViewController: UIViewController {
	
	private let id: Int
	
	private let videoService: VideosServiceType
	
	private lazy var scrollView = UIScrollView()
	private lazy var containerView = UIView()
	private lazy var webView = WKWebView()
	private lazy var authRequiredView = AuthRequiredView()
	private lazy var mainInfoView = MovieMainInfoView()
	
	private lazy var separatorView = UIView()
	
	private lazy var detailInfoView = MovieDetailInfoView()
	private lazy var showFilmButton = BlueBorderButton(title: "СМОТРЕТЬ ФИЛЬМ", target: self, action: #selector(onShowFilmButtonTap))

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
		view.backgroundColor = .white
		webView.isHidden = true
		
		for product in StoreKitService.shared.products {
			if let expiresDate = StoreKitService.shared.expirationDate(for: product.productIdentifier),
				expiresDate > Date() {
				authRequiredView.isHidden = true
				webView.isHidden = false
				showFilmButton.isHidden = true
			}
		}
		webView.scrollView.isScrollEnabled = false
		separatorView.backgroundColor = .separator
		webView.backgroundColor = .black
		
		view.addSubview(scrollView)
		scrollView.addSubview(containerView)
		containerView.addSubview(webView)
		containerView.addSubview(authRequiredView)
		containerView.addSubview(mainInfoView)
		containerView.addSubview(separatorView)
		containerView.addSubview(detailInfoView)
		containerView.addSubview(showFilmButton)
		
		scrollView.translatesAutoresizingMaskIntoConstraints = false
		let frameGuide = scrollView.frameLayoutGuide
		let contentGuide = scrollView.contentLayoutGuide
		
		frameGuide.snp.makeConstraints {
			$0.edges.equalTo(view)
			$0.width.equalTo(contentGuide)
		}
		
		containerView.snp.makeConstraints {
			$0.edges.equalTo(contentGuide)
		}
		webView.snp.makeConstraints {
			$0.leading.trailing.top.equalToSuperview()
		}
		authRequiredView.snp.makeConstraints {
			$0.left.top.right.equalToSuperview()
			$0.bottom.equalTo(webView)
		}
		mainInfoView.snp.makeConstraints {
			$0.top.equalTo(authRequiredView.snp.bottom)
			$0.left.right.equalToSuperview()
		}
		separatorView.snp.makeConstraints {
			$0.top.equalTo(mainInfoView.snp.bottom)
			$0.left.right.equalToSuperview()
			$0.height.equalTo(1)
		}
		detailInfoView.snp.makeConstraints {
			$0.top.equalTo(separatorView.snp.bottom)
			$0.left.right.equalToSuperview()
		}
		showFilmButton.snp.makeConstraints {
			$0.top.equalTo(detailInfoView.snp.bottom).offset(10)
			$0.centerX.equalToSuperview()
			$0.bottom.left.right.equalToSuperview().inset(16)
			$0.height.equalTo(44)
		}

	}
	
    override func viewDidLoad() {
        super.viewDidLoad()

		navigationItem.largeTitleDisplayMode = .never
		loadData()
    }
	
	private func loadData() {
		videoService.detailMovie(id: id) { [weak self] (result) in
			guard let self = self else { return }
			guard let detailModel = try? result.get() else { return }
			self.title = detailModel.title
			self.fill(detailModel: detailModel)
		}
//		switch movie.type {
//		case .film:
//			videoService.detailMovie(id: movie.id) { [weak self] (result) in
//				guard let self = self else { return }
//				guard let detailModel = try? result.get() else { return }
//				self.title = detailModel.title
//				self.fill(detailModel: detailModel)
//			}
//		case .serial:
//			videoService.detailSerial(id: movie.id) { [weak self] (result) in
//				guard let self = self else { return }
//				guard let detailModel = try? result.get() else { return }
//				self.fill(detailModel: detailModel)
//			}
//		case .funShow:
//			break
//		}
	}
	
	private func fill(detailModel: DetailMovieModel) {
		if let tvigleId = detailModel.tvigleId,
			let movieUrl = URL(string: "http://cloud.tvigle.ru/video/\(tvigleId)/") {
			webView.load(URLRequest(url: movieUrl))
		}
		mainInfoView.fill(movie: detailModel)
		detailInfoView.fill(detailModel: detailModel)
	}

	@objc
	private func onShowFilmButtonTap(sender: UIButton) {
		let subscriptionVC = SubscriptionViewController()
		present(subscriptionVC, animated: true)
	}
}
