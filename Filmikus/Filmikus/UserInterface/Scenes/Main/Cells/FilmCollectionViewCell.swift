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
		
		contentView.backgroundColor = .clear
		labelTitle.font = .boldSystemFont(ofSize: 12)
		labelTitle.textColor = .white
		labelGenres.font = .systemFont(ofSize: 12)
		labelGenres.textColor = .white
		labelCountryYear.font = .systemFont(ofSize: 12)
		labelCountryYear.textColor = .lightText

		contentView.addSubview(imageView)
		contentView.addSubview(labelTitle)
		contentView.addSubview(labelGenres)
		contentView.addSubview(labelCountryYear)
		
		imageView.snp.makeConstraints {
			$0.left.top.right.equalToSuperview()
		}
		labelTitle.snp.makeConstraints {
			$0.top.equalTo(imageView.snp.bottom)
			$0.leading.trailing.equalToSuperview()
		}
		labelGenres.snp.makeConstraints {
			$0.top.equalTo(labelTitle.snp.bottom)
			$0.leading.trailing.equalToSuperview()
		}
		labelCountryYear.snp.makeConstraints {
			$0.top.equalTo(labelGenres.snp.bottom)
			$0.leading.trailing.bottom.equalToSuperview()
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
