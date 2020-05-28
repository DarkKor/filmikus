//
//  MovieMainInfoView.swift
//  Filmikus
//
//  Created by Андрей Козлов on 15.05.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import UIKit
import SnapKit

class MovieMainInfoView: UIView {

	private let posterImageView = UIImageView()
	private lazy var stackView: UIStackView = {
		let stack = UIStackView(arrangedSubviews: [
			titleLabel, ratingLabel, genresLabel, countryLabel
		])
		stack.distribution = .equalSpacing
		stack.axis = .vertical
		return stack
	}()
	private let titleLabel = UILabel()
	private let ratingLabel = UILabel()
	private let genresLabel = UILabel()
	private let countryLabel = UILabel()
	
	init() {
		super.init(frame: .zero)
		
		titleLabel.font = .boldSystemFont(ofSize: 17)
		ratingLabel.textColor = .systemOrange
		
		addSubview(posterImageView)
		addSubview(stackView)

		posterImageView.snp.makeConstraints {
			$0.top.left.bottom.equalToSuperview()
			$0.width.equalToSuperview().multipliedBy(0.33)
			$0.height.equalTo(posterImageView.snp.width).multipliedBy(1.49)
		}
		stackView.snp.makeConstraints {
			$0.left.equalTo(posterImageView.snp.right).offset(20)
			$0.centerY.right.equalToSuperview()
			$0.height.equalTo(posterImageView).multipliedBy(0.8)
		}
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		posterImageView.rounded(radius: posterImageView.frame.height / 16)
	}
	
	func fill(movie: MovieModel) {
		let imageUrl = URL(string: movie.imageUrl)
		posterImageView.kf.indicatorType = .activity
		posterImageView.kf.setImage(
			with: imageUrl,
			placeholder: nil,
			options: [
				.transition(.fade(0.25))
			]
		)
		titleLabel.text = movie.title
		ratingLabel.text = "⭐️8.8"
//		genresLabel.text = movie.genres.first
//		countryLabel.text = movie.country
	}
	
}
