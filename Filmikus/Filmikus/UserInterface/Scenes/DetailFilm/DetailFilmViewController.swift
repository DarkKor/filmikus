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
		
		let frameGuide = scrollView.frameLayoutGuide
		let contentGuide = scrollView.contentLayoutGuide
		
		view.addSubview(scrollView)
		scrollView.addSubview(containerView)
		containerView.addSubview(mainInfoView)
		containerView.addSubview(directorsLabel)
		containerView.addSubview(actorsLabel)
		containerView.addSubview(descriptionLabel)
		containerView.addSubview(webView)
		scrollView.translatesAutoresizingMaskIntoConstraints = false
		frameGuide.snp.makeConstraints {
			$0.edges.equalTo(view)
			$0.width.equalTo(contentGuide)
		}
		
		containerView.snp.makeConstraints {
			$0.edges.equalTo(contentGuide)
		}
		
		mainInfoView.snp.makeConstraints {
			$0.left.top.right.equalToSuperview().inset(16)
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
			$0.leading.trailing.equalToSuperview().inset(16)
		}
		webView.snp.makeConstraints {
			$0.top.equalTo(descriptionLabel.snp.bottom).offset(10)
			$0.leading.trailing.bottom.equalToSuperview().inset(16)
			$0.height.equalTo(200)
		}
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()

		title = film.title
		navigationItem.largeTitleDisplayMode = .never
		mainInfoView.fill(film: film)
		
		directorsLabel.text = "Режисеры:  Оливье Накаш ,  Эрик Толедано"
		actorsLabel.text = "Актеры:  Абса Дьяту Тур ,  Альба Гайя Крагеде Беллуджи ,  Анн Ле Ни ,  Жозефин Де Мо ,  Клотильд Молле ,  Одри Флеро ,  Омар Си , Салимата Камате ,  Сирил Менди ,  Франсуа Клюзе  "
		descriptionLabel.text = "Описание: Пострадав в результате несчастного случая, богатый аристократ Филипп нанимает в помощники человека, который менее всего подходит для этой работы, — молодого жителя предместья Дрисса, только что освободившегося из тюрьмы. Несмотря на то, что Филипп прикован к инвалидному креслу, Дриссу удается привнести в размеренную жизнь аристократа дух приключений.Несмотря на то, что Филипп прикован к инвалидному креслу, Дриссу удается привнести в размеренную жизнь аристократа дух приключений.Несмотря на то, что Филипп прикован к инвалидному креслу, Дриссу удается привнести в размеренную жизнь аристократа дух приключений.Несмотря на то, что Филипп прикован к инвалидному креслу, Дриссу удается привнести в размеренную жизнь аристократа дух приключений."
    }
    

}
