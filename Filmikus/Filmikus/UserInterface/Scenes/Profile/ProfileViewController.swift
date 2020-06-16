//
//  ProfileViewController.swift
//  Filmikus
//
//  Created by Андрей Козлов on 13.05.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import UIKit
import SnapKit

class ProfileViewController: UIViewController {
	
	private lazy var registerLabel = UILabel()
	private lazy var signUpButton = BlueBorderButton(title: "РЕГИСТРАЦИЯ", target: self, action: #selector(onSignUpButtonTap))
	private lazy var signInButton = BlueButton(title: "ВОЙТИ", target: self, action: #selector(onSignInButtonTap))
	
	override func loadView() {
		view = UIView()
		view.backgroundColor = .white
		
		view.addSubview(registerLabel)
		view.addSubview(signUpButton)
		view.addSubview(signInButton)
		
		registerLabel.text = "Авторизуйтесь, чтобы получить доступ к контенту"
		registerLabel.textColor = .appDarkBlue
		registerLabel.font = .boldSystemFont(ofSize: 20)
		registerLabel.numberOfLines = 0
		registerLabel.textAlignment = .center
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
			$0.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
			$0.centerX.equalToSuperview()
			$0.height.equalTo(44)
			$0.width.equalTo(signUpButton)
		}
	}

    override func viewDidLoad() {
        super.viewDidLoad()

		title = "Профиль"
		

	}
	
	@objc
	private func onSignUpButtonTap(sender: UIButton) {
		let signUpVC = SignUpViewController()
		navigationController?.present(signUpVC, animated: true)
	}
    
	@objc
	private func onSignInButtonTap(sender: UIButton) {
		let signInVC = SignInViewController()
		navigationController?.present(signInVC, animated: true)
	}
}
