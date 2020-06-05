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
	
	private let videoService: VideosServiceType
	
	private lazy var scrollView = UIScrollView()
	private lazy var containerView = UIView()
	private lazy var webView = WKWebView()
	private lazy var authRequiredView: AuthRequiredView = {
		let view = AuthRequiredView()
		view.delegate = self
		return view
	}()
	
	private lazy var titleLabel: UILabel = {
		let label = UILabel()
		label.font = .boldSystemFont(ofSize: 20)
		return label
	}()
	private lazy var descriptionLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 14)
		label.numberOfLines = 0
		return label
	}()
	private lazy var showFilmButton = BlueBorderButton(title: "СМОТРЕТЬ ВИДЕО", target: self, action: #selector(onShowFilmButtonTap))
	
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
		webView.backgroundColor = .black
		
		view.addSubview(scrollView)
		scrollView.addSubview(containerView)
		containerView.addSubview(webView)
		containerView.addSubview(authRequiredView)
		containerView.addSubview(showFilmButton)
		containerView.addSubview(titleLabel)
		containerView.addSubview(descriptionLabel)
		
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
		titleLabel.snp.makeConstraints {
			$0.top.equalTo(authRequiredView.snp.bottom).offset(20)
			$0.leading.trailing.equalToSuperview().inset(16)

		}
		descriptionLabel.snp.makeConstraints {
			$0.top.equalTo(titleLabel.snp.bottom).offset(20)
			$0.leading.trailing.equalToSuperview().inset(16)

		}
		showFilmButton.snp.makeConstraints {
			$0.top.equalTo(descriptionLabel.snp.bottom).offset(10)
			$0.centerX.equalToSuperview()
			$0.width.equalToSuperview().dividedBy(2)
			$0.bottom.equalToSuperview().inset(16)
			$0.height.equalTo(44)
		}
		
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		navigationItem.largeTitleDisplayMode = .never
		loadData()
	}
	
	private func loadData() {
		videoService.detailFunShow(id: id) { [weak self] (result) in
			guard let self = self else { return }
			guard let detailModel = try? result.get() else { return }
			self.title = detailModel.title
			self.fill(detailModel: detailModel)
		}
	}
	
	private func fill(detailModel: DetailFunShowModel) {
		titleLabel.text = detailModel.title
		descriptionLabel.text = detailModel.descr
//		if let tvigleId = detailModel.tvigleId,
//			let movieUrl = URL(string: "http://cloud.tvigle.ru/video/\(tvigleId)/") {
//			webView.load(URLRequest(url: movieUrl))
//		}
	}
	
	@objc
	private func onShowFilmButtonTap(sender: UIButton) {
		tabBarController?.selectedIndex = 4
	}
}

// MARK: - AuthRequiredViewDelegate

extension DetailFunShowViewController: AuthRequiredViewDelegate {
	
	func authRequiredViewDidSelectSignIn(_ view: AuthRequiredView) {
		tabBarController?.selectedIndex = 4
	}
	
	func authRequiredViewDidSelectSignUp(_ view: AuthRequiredView) {
		tabBarController?.selectedIndex = 4
	}
}
