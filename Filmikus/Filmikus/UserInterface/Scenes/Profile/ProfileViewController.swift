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
	
	private lazy var segmentControl: UISegmentedControl = {
		let segment = UISegmentedControl(items: ["По логину", "По номеру телефона"])
		segment.addTarget(self, action: #selector(segmentControlChanged), for: .valueChanged)
		segment.backgroundColor = .white
		segment.selectedSegmentIndex = 0
		segment.selectedSegmentTintColor = .appBlue
		segment.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
		return segment
	}()
	
	private lazy var loginTextField = UnderlinedTextField(placeholder: "Введите логин")
	private lazy var passwordTextField: UnderlinedTextField = {
		let textField = UnderlinedTextField(placeholder: "Введите пароль")
		textField.isSecureTextEntry = true
		return textField
	}()
	private lazy var phoneTextField: UnderlinedTextField = {
		let textField = UnderlinedTextField(placeholder: "Введите номер телефона")
		textField.keyboardType = .phonePad
		textField.isHidden = true
		return textField
	}()
	
	private lazy var signUpButton = BlueButton(title: "РЕГИСТРАЦИЯ", target: self, action: #selector(onSignUpButtonTap))
	private lazy var signInButton = BlueButton(title: "ВОЙТИ", target: self, action: #selector(onSignInButtonTap))
	
	override func loadView() {
		view = UIView()
		view.backgroundColor = .white
		
		view.addSubview(segmentControl)
		view.addSubview(loginTextField)
		view.addSubview(passwordTextField)
		view.addSubview(phoneTextField)

		view.addSubview(signUpButton)
		view.addSubview(signInButton)
		
		segmentControl.snp.makeConstraints {
			$0.top.equalTo(view.safeAreaLayoutGuide).offset(30)
			$0.centerX.equalToSuperview()
		}

		loginTextField.snp.makeConstraints {
			$0.center.equalToSuperview()
			$0.leading.equalToSuperview().offset(20)
			$0.trailing.equalToSuperview().offset(-20)
		}
		passwordTextField.snp.makeConstraints {
			$0.top.equalTo(loginTextField.snp.bottom).offset(20)
			$0.leading.equalToSuperview().offset(20)
			$0.trailing.equalToSuperview().offset(-20)
		}
		phoneTextField.snp.makeConstraints {
			$0.center.equalToSuperview()
			$0.leading.equalToSuperview().offset(20)
			$0.trailing.equalToSuperview().offset(-20)
		}
		signUpButton.snp.makeConstraints {
			$0.top.equalTo(passwordTextField.snp.bottom).offset(20)
			$0.centerX.equalToSuperview()
			$0.leading.equalToSuperview().offset(20)
			$0.trailing.equalToSuperview().offset(-20)
			$0.height.equalTo(44)
		}
		signInButton.snp.makeConstraints {
			$0.top.equalTo(signUpButton.snp.bottom).offset(20)
			$0.centerX.equalToSuperview()
			$0.leading.equalToSuperview().offset(20)
			$0.trailing.equalToSuperview().offset(-20)
			$0.height.equalTo(44)
		}
	}

    override func viewDidLoad() {
        super.viewDidLoad()

		title = "Профиль"
		

	}
	
	@objc
	private func segmentControlChanged(sender: UISegmentedControl) {
		let isLoginAuth = sender.selectedSegmentIndex == 0
		loginTextField.isHidden = !isLoginAuth
		passwordTextField.isHidden = !isLoginAuth
		phoneTextField.isHidden = isLoginAuth
	}
	
	@objc
	private func onSignUpButtonTap(sender: UIButton) {
		
	}
    
	@objc
	private func onSignInButtonTap(sender: UIButton) {
		
	}

}
