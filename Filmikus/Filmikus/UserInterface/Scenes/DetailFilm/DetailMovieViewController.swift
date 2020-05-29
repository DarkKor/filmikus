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
	
	private let movie: MovieModel
	
	private let videoService: VideosServiceType
	
	private lazy var scrollView = UIScrollView()
	private lazy var containerView = UIView()
	private lazy var webView = WKWebView()
	private lazy var authRequiredView = AuthRequiredView()
	private lazy var mainInfoView = MovieMainInfoView()
	
	private lazy var separatorView = UIView()
	
	private lazy var directorsLabel = UILabel()
	private lazy var actorsLabel = UILabel()
	private lazy var descriptionLabel = UILabel()
	private lazy var showFilmButton = BlueButton(title: "СМОТРЕТЬ ФИЛЬМ", target: self, action: #selector(onShowFilmButtonTap))

	init(
		movie: MovieModel,
		videoService: VideosServiceType = VideosService()
	) {
		self.movie = movie
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
		webView.scrollView.isScrollEnabled = false
		separatorView.backgroundColor = .separator
		webView.backgroundColor = .systemRed
		directorsLabel.numberOfLines = 0
		actorsLabel.numberOfLines = 0
		descriptionLabel.numberOfLines = 0
		
		view.addSubview(scrollView)
		scrollView.addSubview(containerView)
		containerView.addSubview(webView)
		containerView.addSubview(authRequiredView)
		containerView.addSubview(mainInfoView)
		containerView.addSubview(separatorView)
		containerView.addSubview(directorsLabel)
		containerView.addSubview(actorsLabel)
		containerView.addSubview(descriptionLabel)
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
			$0.leading.trailing.top.equalToSuperview().inset(16)
			$0.height.equalTo(200)
		}
		authRequiredView.snp.makeConstraints {
			$0.left.top.right.equalToSuperview()
//			$0.height.equalTo(200)
		}
		mainInfoView.snp.makeConstraints {
			$0.top.equalTo(authRequiredView.snp.bottom).offset(10)
			$0.left.right.equalToSuperview().inset(16)
		}
		separatorView.snp.makeConstraints {
			$0.top.equalTo(mainInfoView.snp.bottom).offset(10)
			$0.left.right.equalToSuperview()
			$0.height.equalTo(1)
		}
		directorsLabel.snp.makeConstraints {
			$0.top.equalTo(separatorView.snp.bottom).offset(10)
			$0.leading.trailing.equalToSuperview().inset(16)
		}
		actorsLabel.snp.makeConstraints {
			$0.top.equalTo(directorsLabel.snp.bottom).offset(10)
			$0.leading.trailing.equalToSuperview().inset(16)
		}
		descriptionLabel.snp.makeConstraints {
			$0.top.equalTo(actorsLabel.snp.bottom).offset(10)
			$0.leading.trailing.equalToSuperview().inset(16)
		}
		showFilmButton.snp.makeConstraints {
			$0.top.equalTo(descriptionLabel.snp.bottom).offset(10)
			$0.centerX.equalToSuperview()
			$0.bottom.left.right.equalToSuperview().inset(16)
			$0.height.equalTo(44)
		}

	}
	
    override func viewDidLoad() {
        super.viewDidLoad()

		title = movie.title
		navigationItem.largeTitleDisplayMode = .never
//		mainInfoView.fill(movie: movie)
		loadData()
		let youtubeUrl = """
			<iframe width="1024" height="720" src="https://www.youtube.com/embed/T1jIEJ7VjUQ" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
		"""
		
		let iframeUrl = """
		<html>
		<body>
				<iframe width="1024" height="720" src="http://cloud.tvigle.ru/video/5318544/?partnerId=10458" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
		</body>
		</html>
		"""
		webView.loadHTMLString(youtubeUrl, baseURL: nil)
    }
	
	private func loadData() {
		videoService.detailMovie(id: movie.id) { [weak self] (result) in
			guard let self = self else { return }
			guard let detailModel = try? result.get() else { return }
			self.mainInfoView.fill(movie: detailModel)
			self.directorsLabel.attributedText = self.formattedString(
				grayPart: "Режисеры: ",
				blackPart: detailModel.directors.map{ $0.name }.joined(separator: ", ")
			)
			self.actorsLabel.attributedText = self.formattedString(
				grayPart: "Режисеры: ",
				blackPart: detailModel.actors.map{ $0.name }.joined(separator: ", ")
			)
			self.descriptionLabel.attributedText = self.formattedString(
				grayPart: "Режисеры: ",
				blackPart: detailModel.descr
			)
		}
	}
    
	private func formattedString(grayPart: String, blackPart: String) -> NSAttributedString {
		let grayAttributed = NSAttributedString(
			string: grayPart,
			attributes: [
				.foregroundColor: UIColor.appGrayText,
				.font: UIFont.boldSystemFont(ofSize: 12)
			]
		)
		let blackAttributed = NSAttributedString(
			string: blackPart,
			attributes: [
				.foregroundColor: UIColor.black,
				.font: UIFont.systemFont(ofSize: 14)
			]
		)
		let result = NSMutableAttributedString(attributedString: grayAttributed)
		result.append(blackAttributed)
		return result
	}
	
	@objc
	private func onShowFilmButtonTap(sender: UIButton) {
		
	}
}
