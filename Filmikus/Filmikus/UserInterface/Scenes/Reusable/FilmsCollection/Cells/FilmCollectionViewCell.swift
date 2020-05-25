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
    
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		contentView.backgroundColor = .white
		contentView.rounded(radius: frame.size.height / 16)
		layer.shadowOpacity = 0.3
		layer.shadowRadius = 5
		labelTitle.font = .boldSystemFont(ofSize: 14)

		contentView.addSubview(imageView)
		contentView.addSubview(labelTitle)

		labelTitle.setContentCompressionResistancePriority(.required, for: .vertical)
		labelTitle.setContentHuggingPriority(.required, for: .vertical)

		imageView.snp.makeConstraints {
			$0.left.top.right.equalToSuperview()
		}
		labelTitle.snp.makeConstraints {
			$0.top.equalTo(imageView.snp.bottom).offset(10)
			$0.leading.trailing.bottom.equalToSuperview().inset(10)
		}
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
		// disable self-sizing 
		return layoutAttributes
	}
	
	func fill(film: Film) {
		let url = URL(string: film.imageUrl)
		imageView.kf.setImage(with: url)
		labelTitle.text = film.title
	}
}
