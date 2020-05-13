//
//  UnderlinedTextField.swift
//  Filmikus
//
//  Created by Андрей Козлов on 13.05.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import UIKit

class UnderlinedTextField: UITextField {
	
    private let padding = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
	
	private let bottomBorder = CALayer()

	init(placeholder: String = "") {
		super.init(frame: .zero)
		
		attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [.foregroundColor: UIColor.appPlaceholderGray])
				
		bottomBorder.backgroundColor = UIColor.appUnderlineGray.cgColor
		layer.addSublayer(bottomBorder)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		let size = bounds.size
		let borderHeight: CGFloat = 1.0
		bottomBorder.frame = CGRect(x: 0, y: size.height - borderHeight, width: size.width, height: borderHeight)
	}
}
