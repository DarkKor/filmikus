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
			titleLabel, ratingLabel, genresLabel, countryLabel, durationLabel, qualityAgeContainer
		])
		stack.distribution = .equalSpacing
		stack.axis = .vertical
		return stack
	}()
	private let titleLabel = UILabel()
	private let ratingLabel = UILabel()
	private let genresLabel = UILabel()
	private let countryLabel = UILabel()
	private let durationLabel = UILabel()
	private let qualityAgeContainer = UIView()
	private let qualityLabel = RoundedBorderLabel()
	private let ageRatingLabel = RoundedBorderLabel()
	
	init() {
		super.init(frame: .zero)
		
		titleLabel.font = .boldSystemFont(ofSize: 17)
		ratingLabel.font = .systemFont(ofSize: 14)
		ratingLabel.textColor = .systemOrange
		
		genresLabel.font = .systemFont(ofSize: 14)
		genresLabel.numberOfLines = 0
		countryLabel.font = .systemFont(ofSize: 14)
		countryLabel.numberOfLines = 0
		durationLabel.font = .systemFont(ofSize: 14)

		addSubview(posterImageView)
		addSubview(stackView)
		qualityAgeContainer.addSubview(qualityLabel)
		qualityAgeContainer.addSubview(ageRatingLabel)
		stackView.setContentHuggingPriority(.required, for: .vertical)
		qualityLabel.setContentCompressionResistancePriority(.required, for: .vertical)

		posterImageView.snp.makeConstraints {
			$0.top.left.bottom.equalToSuperview().inset(16)
			$0.width.equalToSuperview().multipliedBy(0.33)
			$0.height.equalTo(posterImageView.snp.width).multipliedBy(1.49)
		}
		stackView.snp.makeConstraints {
			$0.left.equalTo(posterImageView.snp.right).offset(16)
			$0.centerY.right.equalToSuperview()
			$0.top.equalTo(posterImageView).offset(10)
			$0.bottom.equalToSuperview().inset(16)
		}
		qualityLabel.snp.makeConstraints {
			$0.top.leading.bottom.equalToSuperview()
		}
		ageRatingLabel.snp.makeConstraints {
			$0.leading.equalTo(qualityLabel.snp.trailing).offset(5)
			$0.centerY.equalTo(qualityLabel)
		}
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		posterImageView.rounded(radius: posterImageView.frame.height / 16)
	}
	
	func fill(movie: DetailMovieModel) {
		let imageUrl = URL(string: movie.imageUrl.high)
		posterImageView.kf.indicatorType = .activity
		posterImageView.kf.setImage(
			with: imageUrl,
			placeholder: nil,
			options: [
				.transition(.fade(0.25))
			]
		)
		titleLabel.text = movie.title
		let rating = NSMutableAttributedString()
		let imageAttachment = NSTextAttachment()
		imageAttachment.image = UIImage(named: "rating")
		let imageString = NSAttributedString(attachment: imageAttachment)
		rating.append(imageString)
		rating.append(NSAttributedString(string: " \(movie.rating)"))
		ratingLabel.attributedText = rating
		let categories = movie.categories.map {
			NSAttributedString(
				string: "\($0.title) "//,
//				attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue]
			)
		}
		let attributedCategories = NSMutableAttributedString()
		categories.forEach(attributedCategories.append)
		let countries = movie.countries.map {
			NSAttributedString(
				string: "\($0.title) "//,
//				attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue]
			)
		}
		let attributedCountries = NSMutableAttributedString()
		countries.forEach(attributedCountries.append)
		
		genresLabel.attributedText = attributedCategories
		countryLabel.attributedText = attributedCountries
		durationLabel.text = "\(movie.duration) мин "
		qualityLabel.text = movie.quality
		ageRatingLabel.text = movie.ageRating
	}
	
}
