//
//  RoundedBorderLabel.swift
//  Filmikus
//
//  Created by Андрей Козлов on 29.05.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import UIKit

class RoundedBorderLabel: UILabel {
	
	private let insets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
	
	override var intrinsicContentSize: CGSize {
		guard let text = text, !text.isEmpty else { return .zero }
		let defaultSize = super.intrinsicContentSize
		let width = defaultSize.width + insets.left + insets.right
		let height = defaultSize.height + insets.top + insets.bottom
		return CGSize(width: width, height: height)
	}
	
	override var bounds: CGRect {
		didSet {
			layer.borderColor = UIColor.separator.cgColor
			layer.borderWidth = 1.0
			rounded(radius: bounds.height / 2)
		}
	}
	
	init() {
		super.init(frame: .zero)
		
		font = .boldSystemFont(ofSize: 12)
		textColor = .secondaryLabel
		textAlignment = .center
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
