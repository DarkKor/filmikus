//
//  VideoCollectionViewCell.swift
//  Filmikus
//
//  Created by Андрей Козлов on 21.05.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import UIKit

class VideoCollectionViewCell: ReusableCollectionViewCell {
	
	private let imageView = UIImageView()
	private let titleLabel = UILabel()
    
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		contentView.backgroundColor = .clear
		contentView.addSubview(imageView)
		contentView.addSubview(titleLabel)

		titleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
		titleLabel.setContentHuggingPriority(.required, for: .vertical)
		imageView.rounded(radius: frame.height / 16)
		
		imageView.snp.makeConstraints {
			$0.left.top.right.equalToSuperview()
		}
		titleLabel.snp.makeConstraints {
			$0.top.equalTo(imageView.snp.bottom)
			$0.leading.trailing.bottom.equalToSuperview()
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
	
	func fill(video: Video) {
		let imageUrl = URL(string: video.imageUrl)
		imageView.kf.setImage(with: imageUrl)
		titleLabel.text = video.title
	}
}
