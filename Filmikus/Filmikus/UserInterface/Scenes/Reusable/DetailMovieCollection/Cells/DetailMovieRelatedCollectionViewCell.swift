//
//  DetailMovieRelatedCollectionViewCell.swift
//  Filmikus
//
//  Created by Андрей Козлов on 09.06.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import UIKit

class DetailMovieRelatedCollectionViewCell: ReusableCollectionViewCell {
    
	private let imageView = UIImageView()
	private let labelTitle = UILabel()
    
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		contentView.backgroundColor = .white
		contentView.rounded(radius: frame.size.height / 16)
		layer.shadowOpacity = 0.3
		layer.shadowRadius = 5
		labelTitle.font = .boldSystemFont(ofSize: 14)
		imageView.backgroundColor = .appLightGray
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
	
	override func prepareForReuse() {
		super.prepareForReuse()
		
		labelTitle.text = nil
		imageView.image = nil
	}
	
	override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
		// disable self-sizing
		return layoutAttributes
	}
	
	func fill(movie: RelatedMovie) {
		let url = URL(string: movie.imageUrl ?? "")
		imageView.kf.indicatorType = .activity
		imageView.kf.setImage(
			with: url,
			placeholder: nil,
			options: [
				.transition(.fade(0.25))
			]
		)
		labelTitle.text = movie.title
		labelTitle.font = movie.isSelected ? .boldSystemFont(ofSize: 17) : .systemFont(ofSize: 17)
		labelTitle.textColor = movie.isSelected ? .appBlue : .black
	}
}
