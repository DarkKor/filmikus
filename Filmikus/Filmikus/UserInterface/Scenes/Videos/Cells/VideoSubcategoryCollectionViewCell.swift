//
//  VideoSubcategoryCollectionViewCell.swift
//  Filmikus
//
//  Created by Андрей Козлов on 21.05.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import UIKit

class VideoSubcategoryCollectionViewCell: ReusableCollectionViewCell {
	
	private lazy var imageView = UIImageView()
	private lazy var titleLabel = UILabel()
    
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		contentView.backgroundColor = .white
		contentView.rounded(radius: frame.size.height / 16)
		layer.shadowOpacity = 0.3
		layer.shadowRadius = 5
		
		titleLabel.font = .boldSystemFont(ofSize: 16)
		titleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
		titleLabel.setContentHuggingPriority(.required, for: .vertical)

		contentView.addSubview(imageView)
		contentView.addSubview(titleLabel)
		
		imageView.snp.makeConstraints {
			$0.left.top.right.equalToSuperview()
		}
		titleLabel.snp.makeConstraints {
			$0.top.equalTo(imageView.snp.bottom).offset(10)
			$0.leading.trailing.bottom.equalToSuperview().inset(10)
		}
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func prepareForReuse() {
		super.prepareForReuse()
		
		imageView.image = nil
		titleLabel.text = nil
	}
	
	func fill(videoSubategory: VideoSubcategory) {
		let imageUrl = URL(string: videoSubategory.imageUrl)
		imageView.kf.indicatorType = .activity
		imageView.kf.setImage(
			with: imageUrl,
			placeholder: nil,
			options: [
				.transition(.fade(0.25))
			]
		)
		titleLabel.text = videoSubategory.title
	}
}
