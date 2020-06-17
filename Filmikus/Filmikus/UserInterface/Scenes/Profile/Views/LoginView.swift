//
//  LoginView.swift
//  Filmikus
//
//  Created by Андрей Козлов on 17.06.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import UIKit

protocol LoginViewDelegate: class {
	func loginViewDidSelectSignUp(_ view: LoginView)
	func loginViewDidSelectSignIn(_ view: LoginView)
}

class LoginView: UIView {
	
	weak var delegate: LoginViewDelegate?
	
	private lazy var registerLabel: UILabel = {
		let label = UILabel()
		label.text = "Авторизуйтесь, чтобы получить доступ к контенту"
		label.textColor = .appDarkBlue
		label.font = .boldSystemFont(ofSize: 20)
		label.numberOfLines = 0
		label.textAlignment = .center
		return label
	}()
	private lazy var signUpButton = BlueBorderButton(title: "РЕГИСТРАЦИЯ", target: self, action: #selector(onSignUpButtonTap))
	private lazy var signInButton = BlueButton(title: "ВОЙТИ", target: self, action: #selector(onSignInButtonTap))
	
	init() {
		super.init(frame: .zero)
		
		addSubview(registerLabel)
		addSubview(signUpButton)
		addSubview(signInButton)
		
		registerLabel.snp.makeConstraints {
			$0.centerY.equalToSuperview().priority(.medium)
			$0.bottom.equalTo(signUpButton.snp.top).offset(-20)
			$0.leading.trailing.equalToSuperview().inset(20)
		}
		signUpButton.snp.makeConstraints {
			$0.bottom.equalTo(signInButton.snp.top).offset(-20)
			$0.centerX.equalToSuperview()
			$0.height.equalTo(44)
			if traitCollection.userInterfaceIdiom == .pad {
				$0.width.equalToSuperview().dividedBy(2)
			} else {
				$0.width.equalToSuperview().inset(20)
			}
		}
		signInButton.snp.makeConstraints {
			$0.bottom.equalTo(safeAreaLayoutGuide).inset(20)
			$0.centerX.equalToSuperview()
			$0.height.equalTo(44)
			$0.width.equalTo(signUpButton)
		}
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	@objc
	private func onSignUpButtonTap(sender: UIButton) {
		delegate?.loginViewDidSelectSignUp(self)
	}
    
	@objc
	private func onSignInButtonTap(sender: UIButton) {
		delegate?.loginViewDidSelectSignIn(self)
	}
}
