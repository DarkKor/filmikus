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
	
	private lazy var scrollView: UIScrollView = {
		let scrollView = UIScrollView()
		scrollView.isPagingEnabled = true
		scrollView.showsHorizontalScrollIndicator = false
		return scrollView
	}()
	
	private var buttons: [UIButton] = []

	init() {
		super.init(frame: .zero)
		addSubview(scrollView)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		scrollView.frame = bounds
		let buttonSize = bounds.size
		var x: CGFloat = 0
		for index in buttons.indices {
			buttons[index].frame = CGRect(origin: CGPoint(x: x, y: 0), size: buttonSize)
			x += buttonSize.width
		}
		scrollView.contentSize.width = x
	}
	
	func fill(sliders: [SliderModel] = []) {
		self.sliders = sliders
		buttons.forEach {
			$0.removeFromSuperview()
		}
		buttons = sliders.map {
			let button = UIButton()
			button.addTarget(self, action: #selector(onSliderButtonTap), for: .touchUpInside)
			scrollView.addSubview(button)
			let url = URL(string: $0.imageUrl)
			button.kf.setImage(
				with: url,
				for: .normal,
				options: [
					.transition(.fade(0.25))
				]
			)
			return button
		}
		setNeedsLayout()
	}
	
	@objc
	private func onSliderButtonTap(sender: UIButton) {
		guard let index = buttons.firstIndex(of: sender) else { return }
		delegate?.categoriesHeaderView(self, didSelectSlider: sliders[index])
	}
}
