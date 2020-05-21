//
//  UnderlinedSegmentControl.swift
//  Filmikus
//
//  Created by Андрей Козлов on 21.05.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import UIKit

protocol UnderlinedSegmentControlDelegate: class {
	func underlinedSegmentControl(_ control: UnderlinedSegmentControl, didChangeSelectedIndex index: Int)
}

class UnderlinedSegmentControl: UIView {
	
	weak var delegate: UnderlinedSegmentControlDelegate?
	
	private(set) var selectedIndex: Int = 0 {
		didSet {
			delegate?.underlinedSegmentControl(self, didChangeSelectedIndex: selectedIndex)
		}
	}
	
	private let scrollView = UIScrollView()
	
	private(set) var buttons: [UIButton]
	private lazy var underlinedView: UIView = {
		let view = UIView()
		view.backgroundColor = selectedColor
		return view
	}()
	
	private var normalColor = UIColor.black
	private var selectedColor = UIColor.systemBlue
	
	override var intrinsicContentSize: CGSize {
		let height = buttons.first?.intrinsicContentSize.height ?? 0
		return CGSize(width: 0, height: height + 10)
	}
	
	init(buttons: [String] = []) {
		self.buttons = buttons.map {
			let button = UIButton()
			button.setTitle($0, for: .normal)
			return button
		}
		super.init(frame: .zero)
		addSubview(scrollView)
		self.buttons.forEach {
			$0.setTitleColor(normalColor, for: .normal)
			$0.addTarget(self, action: #selector(onButtonTap), for: .touchUpInside)
			scrollView.addSubview($0)
		}
		self.buttons.first?.setTitleColor(selectedColor, for: .normal)
		scrollView.addSubview(underlinedView)
		scrollView.showsHorizontalScrollIndicator = false
		scrollView.contentInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		scrollView.frame = bounds
		let maxButtonWidth: CGFloat = buttons.map { $0.intrinsicContentSize.width }.reduce(0, { max($0, $1) })
		let buttonSize = CGSize(width: maxButtonWidth + 10, height: scrollView.frame.size.height)
		var x: CGFloat = 0
		for index in buttons.indices {
			buttons[index].frame = CGRect(origin: CGPoint(x: x, y: 0), size: buttonSize)
			if index == selectedIndex {
				underlinedView.frame = CGRect(x: x, y: buttonSize.height - 2, width: buttonSize.width, height: 2)
			}
			x += buttonSize.width
		}
		scrollView.contentSize.width = x
	}
	
	@objc
	private func onButtonTap(sender: UIButton) {
		for (index, button) in buttons.enumerated() {
			let isSelectedButton = button == sender
			button.setTitleColor(isSelectedButton ? selectedColor : normalColor, for: .normal)
			if isSelectedButton {
				selectedIndex = index
				UIView.animate(withDuration: 0.25) {
					self.underlinedView.frame.origin.x = button.frame.minX
				}
			}
		}
	}
}
