//
//  BlueButton.swift
//  Filmikus
//
//  Created by Андрей Козлов on 03.06.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import UIKit

class BlueButton: UIButton {

	private let insets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
	
	override var intrinsicContentSize: CGSize {
		let defaultSize = super.intrinsicContentSize
		let width = defaultSize.width + insets.left + insets.right
		let height = defaultSize.height + insets.top + insets.bottom
		return CGSize(width: width, height: height)
	}
	
//	override var isSelected: Bool {
//		didSet {
//			backgroundColor = isSelected ? .appBlue : .clear
//		}
//	}
//
//	override var isHighlighted: Bool {
//		didSet {
//			backgroundColor = isHighlighted ? .appBlue : .clear
//		}
//	}
	
	init(title: String = "", target: Any?, action: Selector) {
		super.init(frame: .zero)
		addTarget(target, action: action, for: .touchUpInside)
		
		titleLabel?.font = .boldSystemFont(ofSize: 12)
		setTitle(title, for: .normal)
		setTitleColor(.white, for: .normal)
//		setTitleColor(.white, for: .selected)
//		setTitleColor(.white, for: .highlighted)
		backgroundColor = .appBlue
//		layer.borderColor = UIColor.appBlue.cgColor
//		layer.borderWidth = 1.0
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		rounded(radius: bounds.height / 2)
	}
	
}
