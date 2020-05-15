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
	
	private let film: Film
	
	private lazy var scrollView = UIScrollView()
	private lazy var containerView = UIView()
	private lazy var webView = WKWebView()
	private lazy var mainInfoView = FilmMainInfoView()
	
	private lazy var directorsLabel = UILabel()
	private lazy var actorsLabel = UILabel()
	private lazy var descriptionLabel = UILabel()

	init(film: Film) {
		self.film = film
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func loadView() {
		view = UIView()
		view.backgroundColor = .white
		webView.scrollView.isScrollEnabled = false
		webView.backgroundColor = .systemRed
		directorsLabel.numberOfLines = 0
		actorsLabel.numberOfLines = 0
		descriptionLabel.numberOfLines = 0
		
		view.addSubview(scrollView)
		scrollView.addSubview(containerView)
		containerView.addSubview(webView)
		containerView.addSubview(mainInfoView)
		containerView.addSubview(directorsLabel)
		containerView.addSubview(actorsLabel)
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
			$0.leading.trailing.top.equalToSuperview().inset(16)
			$0.height.equalTo(200)
		}
		mainInfoView.snp.makeConstraints {
			$0.top.equalTo(webView.snp.bottom).offset(10)
			$0.left.right.equalToSuperview().inset(16)
			$0.height.equalTo(150)
		}
		directorsLabel.snp.makeConstraints {
			$0.top.equalTo(mainInfoView.snp.bottom).offset(10)
			$0.leading.trailing.equalToSuperview().inset(16)
		}
		actorsLabel.snp.makeConstraints {
			$0.top.equalTo(directorsLabel.snp.bottom).offset(10)
			$0.leading.trailing.equalToSuperview().inset(16)
		}
		descriptionLabel.snp.makeConstraints {
			$0.top.equalTo(actorsLabel.snp.bottom).offset(10)
			$0.leading.trailing.bottom.equalToSuperview().inset(16)
		}

	}
	
    override func viewDidLoad() {
        super.viewDidLoad()

		title = film.title
		navigationItem.largeTitleDisplayMode = .never
		mainInfoView.fill(film: film)
		
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
		
		
		directorsLabel.attributedText = formattedString(grayPart: "Режисеры:", blackPart: "  Оливье Накаш ,  Эрик Толедано")
		actorsLabel.attributedText = formattedString(grayPart: "Актеры:", blackPart: "  Абса Дьяту Тур ,  Альба Гайя Крагеде Беллуджи ,  Анн Ле Ни ,  Жозефин Де Мо ,  Клотильд Молле ,  Одри Флеро ,  Омар Си , Салимата Камате ,  Сирил Менди ,  Франсуа Клюзе  ")
		descriptionLabel.attributedText = formattedString(grayPart: "Описание:", blackPart: " Пострадав в результате несчастного случая, богатый аристократ Филипп нанимает в помощники человека, который менее всего подходит для этой работы, — молодого жителя предместья Дрисса, только что освободившегося из тюрьмы. Несмотря на то, что Филипп прикован к инвалидному креслу, Дриссу удается привнести в размеренную жизнь аристократа дух приключений.Несмотря на то, что Филипп прикован к инвалидному креслу, Дриссу удается привнести в размеренную жизнь аристократа дух приключений.Несмотря на то, что Филипп прикован к инвалидному креслу, Дриссу удается привнести в размеренную жизнь аристократа дух приключений.Несмотря на то, что Филипп прикован к инвалидному креслу, Дриссу удается привнести в размеренную жизнь аристократа дух приключений.")
    }
    
	func formattedString(grayPart: String, blackPart: String) -> NSAttributedString {
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
}
