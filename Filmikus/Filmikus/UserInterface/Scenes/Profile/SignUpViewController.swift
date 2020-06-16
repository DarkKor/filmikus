//
//  SignUpViewController.swift
//  Filmikus
//
//  Created by Андрей Козлов on 14.05.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import UIKit

class SignUpViewController: ViewController {
		
	private let usersService: UsersServiceType = UsersService()
	
	private lazy var descriptionLabel: UILabel = {
		let label = UILabel()
		label.text = "Для того, чтобы получить доступ к нашему сайту, пожалуйста зарегистрируйтесь.\nНа указанный email придет информация о доступе к сайту, и чеки о покупках, если вы будете их совершать."
		label.numberOfLines = 0
		return label
	}()
	
	private lazy var emailTextField: UnderlinedTextField = {
		let textField = UnderlinedTextField(placeholder: "Введите корректный e-mail")
		textField.keyboardType = .emailAddress
		textField.textContentType = .emailAddress
		return textField
	}()
	
	private lazy var nextButton = BlueBorderButton(title: "ДАЛЕЕ", target: self, action: #selector(onNextButtonTap))
	
	private lazy var userTextView: UITextView = {
		let textView = UITextView()
		textView.font = .boldSystemFont(ofSize: 20)
		textView.isEditable = false
		return textView
	}()
	
	override func loadView() {
		view = UIView()
		view.backgroundColor = .white
		view.addSubview(descriptionLabel)
		view.addSubview(emailTextField)
		view.addSubview(nextButton)
		view.addSubview(userTextView)
		
		descriptionLabel.snp.makeConstraints {
			$0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
		}
		emailTextField.snp.makeConstraints {
			$0.top.equalTo(descriptionLabel.snp.bottom).offset(20)
			$0.leading.trailing.equalToSuperview().inset(16)
		}
		nextButton.snp.makeConstraints {
			$0.top.equalTo(emailTextField.snp.bottom).offset(20)
			$0.leading.trailing.equalToSuperview().inset(16)
			$0.height.equalTo(44)
		}
		userTextView.snp.makeConstraints {
			$0.top.equalTo(nextButton.snp.bottom).offset(20)
			$0.leading.trailing.bottom.equalToSuperview().inset(16)
		}
	}

    override func viewDidLoad() {
        super.viewDidLoad()

		title = "Регистрация"
		navigationItem.largeTitleDisplayMode = .never
    }

	@objc
	private func onNextButtonTap(sender: UIButton) {
		guard let text = emailTextField.text else { return }
		guard !text.isEmpty else { return }
		showActivityIndicator()
		usersService.register(email: text) { [weak self] (result) in
			guard let self = self else { return }
			self.hideActivityIndicator()
			guard let userModel = try? result.get() else { return }
			self.showAlert(
				title: "Фильмикус",
				message: userModel.message,
				completion: {
					guard let user = userModel.user else { return }
					self.userTextView.text = "Ваш логин: \(user.username)\nВаш пароль: \(user.password)"
				}
			)
		}
	}
}
