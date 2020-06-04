//
//  SubscriprionSegmentControl.swift
//  Filmikus
//
//  Created by Андрей Козлов on 04.06.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import UIKit

class SubscriprionSegmentControl: UIControl {
	
	private(set) var selectedIndex: Int = 0
	
	override var intrinsicContentSize: CGSize {
//		let size: CGSize = buttons.reduce(.zero) { (result, button) -> CGSize in
//			let intrinsicSize = button.intrinsicContentSize
//			return CGSize(width: result.width + intrinsicSize.width, height: intrinsicSize.height)
//		}
//		return size
		return CGSize(width: 0, height: 100)
	}
	
	private lazy var frameView: UIView = {
		let view = UIView()
		view.layer.borderWidth = 2
		view.layer.borderColor = UIColor.white.cgColor
		return view
	}()
	
	private var buttons: [UIButton] = []
	
	init(segments: [String] = []) {
		super.init(frame: .zero)
		buttons = segments.map {
			let button = UIButton()
			button.addTarget(self, action: #selector(onButtonTap), for: .touchUpInside)
			button.setTitle($0, for: .normal)
			button.setTitleColor(.white, for: .normal)
			button.titleLabel?.lineBreakMode = .byWordWrapping
			button.titleLabel?.textAlignment = .center
			return button
		}
		backgroundColor = .appDarkBlue
		addSubview(frameView)
		buttons.forEach(addSubview)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		guard !buttons.isEmpty else { return }
		frameView.rounded(radius: bounds.height / 16)
		rounded(radius: bounds.height / 16)
		let buttonSize = CGSize(width: bounds.width / CGFloat(buttons.count), height: bounds.height)
		var x: CGFloat = 0
		for index in buttons.indices {
			buttons[index].frame = CGRect(origin: CGPoint(x: x, y: 0), size: buttonSize)
			if index == selectedIndex {
				frameView.frame = CGRect(x: x, y: 0, width: buttonSize.width, height: buttonSize.height)
			}
			x += buttonSize.width
		}
	}
	
	func insert(segment: String) {
		let button = UIButton()
		button.addTarget(self, action: #selector(onButtonTap), for: .touchUpInside)
		button.setTitle(segment, for: .normal)
		button.setTitleColor(.white, for: .normal)
		button.titleLabel?.lineBreakMode = .byWordWrapping
		button.titleLabel?.textAlignment = .center
		buttons.append(button)
		addSubview(button)
		setNeedsLayout()
	}
	
	@objc
	private func onButtonTap(sender: UIButton) {
		guard let index = buttons.firstIndex(of: sender) else { return }
		selectedIndex = index
		UIView.animate(withDuration: 0.25) {
			self.frameView.frame.origin.x = sender.frame.origin.x
		}
		sendActions(for: .valueChanged)
	}
}
