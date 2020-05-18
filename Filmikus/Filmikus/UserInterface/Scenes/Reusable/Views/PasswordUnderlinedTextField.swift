//
//  PasswordUnderlinedTextField.swift
//  Filmikus
//
//  Created by Андрей Козлов on 14.05.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import UIKit

class PasswordUnderlinedTextField: UnderlinedTextField {

	private lazy var secureButton: UIButton = {
		let button = UIButton()
		button.tintColor = .appPlaceholderGray
		button.setImage(UIImage(systemName: "eye.slash"), for: .normal)
		button.addTarget(self, action: #selector(onSecureButtonTap), for: .touchUpInside)
		return button
	}()
	
	override var isSecureTextEntry: Bool {
		didSet {
			let imageName = isSecureTextEntry ? "eye.slash" : "eye"
			secureButton.setImage(UIImage(systemName: imageName), for: .normal)
		}
	}
    
	override init(placeholder: String = "") {
		super.init(placeholder: placeholder)
		textContentType = .password
		isSecureTextEntry = true
		rightView = secureButton
		rightViewMode = .always
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	@objc
	private func onSecureButtonTap(sender: UIButton) {
		isSecureTextEntry.toggle()
	}
}
