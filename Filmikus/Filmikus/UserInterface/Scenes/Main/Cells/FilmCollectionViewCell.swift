//
//  FilmCollectionViewCell.swift
//  Filmikus
//
//  Created by Андрей Козлов on 07.05.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import UIKit
import Kingfisher

class FilmCollectionViewCell: ReusableCollectionViewCell {
	
	private let imageView = UIImageView()
	private let labelTitle = UILabel()
	private let labelGenres = UILabel()
	private let labelCountryYear = UILabel()
    
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		contentView.backgroundColor = .white
		contentView.rounded(radius: 5)
		layer.shadowOpacity = 0.3
		layer.shadowRadius = 5
		labelTitle.font = .boldSystemFont(ofSize: 12)
		labelGenres.font = .systemFont(ofSize: 12)
		labelCountryYear.font = .systemFont(ofSize: 12)

		contentView.addSubview(imageView)
		contentView.addSubview(labelTitle)
		contentView.addSubview(labelGenres)
		contentView.addSubview(labelCountryYear)
		imageView.setContentHuggingPriority(.defaultLow, for: .vertical)
		labelTitle.setContentCompressionResistancePriority(.required, for: .vertical)
		labelGenres.setContentCompressionResistancePriority(.required, for: .vertical)
		labelCountryYear.setContentCompressionResistancePriority(.required, for: .vertical)

		imageView.snp.makeConstraints {
			$0.left.top.right.equalToSuperview()
		}
		labelTitle.snp.makeConstraints {
			$0.top.equalTo(imageView.snp.bottom)
			$0.leading.equalToSuperview().offset(5)
			$0.trailing.equalToSuperview().offset(-5)
		}
		labelGenres.snp.makeConstraints {
			$0.top.equalTo(labelTitle.snp.bottom)
			$0.leading.equalToSuperview().offset(5)
			$0.trailing.equalToSuperview().offset(-5)
		}
		labelCountryYear.snp.makeConstraints {
			$0.top.equalTo(labelGenres.snp.bottom)
			$0.leading.equalToSuperview().offset(5)
			$0.trailing.equalToSuperview().offset(-5)
			$0.bottom.equalToSuperview()
		}
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func fill(film: Film) {
		let url = URL(string: film.imageUrl)
		imageView.kf.setImage(with: url)
		labelTitle.text = film.title
		labelGenres.text = film.genres.reduce("", { $0.isEmpty ? "\($1)," : "\($0) \($1)," })
		labelCountryYear.text = "\(film.country), \(film.year)"
	}
}
