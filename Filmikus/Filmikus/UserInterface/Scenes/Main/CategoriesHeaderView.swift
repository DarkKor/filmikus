//
//  CategoriesHeaderView.swift
//  Filmikus
//
//  Created by Андрей Козлов on 13.05.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import UIKit

protocol CategoriesHeaderViewDelegate: class {
	func categoriesHeaderView(_ view: CategoriesHeaderView, didSelectSlider slider: SliderModel)
}

class CategoriesHeaderView: UIView {
	
	weak var delegate: CategoriesHeaderViewDelegate?
	
	private var sliders: [SliderModel] = []
	
	private lazy var sliderButton: UIButton = {
		let button = UIButton()
		button.addTarget(self, action: #selector(onSliderButtonTap), for: .touchUpInside)
		return button
	}()

	init() {
		super.init(frame: .zero)
		
		addSubview(sliderButton)
		
		sliderButton.snp.makeConstraints {
			$0.edges.equalToSuperview()
		}
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func fill(sliders: [SliderModel] = []) {
		self.sliders = sliders
		guard let slider = sliders.first else { return }
		let url = URL(string: slider.imageUrl)
		sliderButton.kf.setImage(
			with: url,
			for: .normal,
			options: [
				.transition(.fade(0.25))
			]
		)
	}
	
	@objc
	private func onSliderButtonTap(sender: UIButton) {
		guard let slider = sliders.first else { return }
		delegate?.categoriesHeaderView(self, didSelectSlider: slider)
	}
}
