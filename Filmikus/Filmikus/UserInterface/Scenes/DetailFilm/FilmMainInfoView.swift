//
//  FilmMainInfoView.swift
//  Filmikus
//
//  Created by Андрей Козлов on 15.05.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import UIKit
import SnapKit

class FilmMainInfoView: UIView {

	private lazy var posterImageView = UIImageView()
	private lazy var titleLabel = UILabel()
	private lazy var ratingLabel = UILabel()
	private lazy var genresLabel = UILabel()
	private lazy var countryLabel = UILabel()
	
	init() {
		super.init(frame: .zero)
		
		addSubview(posterImageView)
		addSubview(titleLabel)
		addSubview(ratingLabel)
		addSubview(genresLabel)
		addSubview(countryLabel)

		posterImageView.snp.makeConstraints {
			$0.top.left.bottom.equalToSuperview()
			$0.width.equalToSuperview().multipliedBy(0.25)
		}
		titleLabel.snp.makeConstraints {
			$0.left.equalTo(posterImageView.snp.right).offset(10)
			$0.top.right.equalToSuperview()
		}
		ratingLabel.snp.makeConstraints {
			$0.top.equalTo(titleLabel.snp.bottom).offset(5)
			$0.left.equalTo(posterImageView.snp.right).offset(10)
		}
		genresLabel.snp.makeConstraints {
			$0.top.equalTo(ratingLabel.snp.bottom).offset(5)
			$0.left.equalTo(posterImageView.snp.right).offset(10)
		}
		countryLabel.snp.makeConstraints {
			$0.top.equalTo(genresLabel.snp.bottom).offset(5)
			$0.left.equalTo(posterImageView.snp.right).offset(10)
		}
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func fill(film: Film) {
		let imageUrl = URL(string: film.imageUrl)
		posterImageView.kf.indicatorType = .activity
		posterImageView.kf.setImage(
			with: imageUrl,
			placeholder: nil,
			options: [
				.transition(.fade(0.25))
			]
		)
		titleLabel.text = film.title
		ratingLabel.text = "8.8"
		genresLabel.text = film.genres.first
		countryLabel.text = film.country
	}
	
}
