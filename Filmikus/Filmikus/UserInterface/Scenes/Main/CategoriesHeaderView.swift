//
//  CategoriesHeaderView.swift
//  Filmikus
//
//  Created by Андрей Козлов on 13.05.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import UIKit

class CategoriesHeaderView: UIView {
	
	private let imageView = UIImageView()

	init() {
		super.init(frame: .zero)
				
		addSubview(imageView)
		imageView.snp.makeConstraints {
			$0.edges.equalToSuperview()
		}
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func fill(slider: SliderModel) {
		let url = URL(string: slider.imageUrl)
		imageView.kf.indicatorType = .activity
		imageView.kf.setImage(
			with: url,
			placeholder: nil,
			options: [
				.transition(.fade(0.25))
			]
		)
	}
	
}
