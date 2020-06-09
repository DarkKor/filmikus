//
//  AuthRequiredView.swift
//  Filmikus
//
//  Created by Андрей Козлов on 27.05.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import UIKit

protocol AuthRequiredViewDelegate: class {
	func authRequiredViewDidSelectSignIn(_ view: AuthRequiredView)
	func authRequiredViewDidSelectSignUp(_ view: AuthRequiredView)
}

class AuthRequiredView: UIView {
	
	weak var delegate: AuthRequiredViewDelegate?
	
	private let eyeImageView = UIImageView(image: UIImage(named: "eye"))
	private let textContainer = UIView()
	private lazy var authTextView: UITextView = {
		let textView = UITextView()
		textView.delegate = self
		textView.isScrollEnabled = false
		return textView
	}()
	
	init() {
		super.init(frame: .zero)
		backgroundColor = .appDarkBlue
		textContainer.backgroundColor = .white
		
		let authAttributedText = NSMutableAttributedString(string: "Для просмотра видео ")
		let authLink = NSAttributedString(
			string: "войдите",
			attributes: [.link: "filmikus://com.signIn.app"]
		)
		authAttributedText.append(authLink)
		authAttributedText.append(NSAttributedString(string: " или "))
		let registerLink = NSAttributedString(
			string: "зарегистрируйтесь",
			attributes: [.link: "filmikus://com.signUp.app"]
		)
		authAttributedText.append(registerLink)
		authTextView.linkTextAttributes = [
			.foregroundColor: UIColor.black,
			.underlineStyle: NSUnderlineStyle.single.rawValue
		]
		let style = NSMutableParagraphStyle()
		style.alignment = .center
		authAttributedText.addAttributes(
			[.paragraphStyle: style],
			range: NSRange(location: 0, length: authAttributedText.string.count)
		)
		authTextView.attributedText = authAttributedText
		
		addSubview(textContainer)
		addSubview(eyeImageView)
		textContainer.addSubview(authTextView)
		
		textContainer.snp.makeConstraints {
			$0.edges.equalToSuperview().inset(40)
		}
		authTextView.snp.makeConstraints {
			$0.edges.equalToSuperview().inset(20)
		}
		eyeImageView.snp.makeConstraints {
			$0.centerX.equalTo(textContainer)
			$0.centerY.equalTo(textContainer.snp.top)
			$0.width.height.equalTo(40)
		}

	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		textContainer.rounded(radius: textContainer.frame.height / 16)
	}
}

extension AuthRequiredView: UITextViewDelegate {
	func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
		guard interaction == .invokeDefaultAction else { return false }
		switch URL.absoluteString {
		case "filmikus://com.signIn.app":
			delegate?.authRequiredViewDidSelectSignIn(self)
		case "filmikus://com.signUp.app":
			delegate?.authRequiredViewDidSelectSignUp(self)
		default:
			break
		}
		return false
	}
}
