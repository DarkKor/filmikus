//
//  SignUpViewController.swift
//  Filmikus
//
//  Created by Андрей Козлов on 14.05.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import UIKit

class SignUpViewController: ViewController {
		
	private let userFacade: UserFacadeType = UserFacade()

	private lazy var closeButton: UIButton = {
		let button = UIButton()
		button.tintColor = .appBlue
		button.setImage(UIImage(systemName: "xmark"), for: .normal)
		button.addTarget(self, action: #selector(onCloseButtonTap), for: .touchUpInside)
		return button
	}()
	
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
		
		view.addSubview(closeButton)
		view.addSubview(descriptionLabel)
		view.addSubview(emailTextField)
		view.addSubview(nextButton)
		view.addSubview(userTextView)
		
		closeButton.snp.makeConstraints {
			$0.top.right.equalTo(view.safeAreaLayoutGuide).inset(20)
		}
		descriptionLabel.snp.makeConstraints {
			$0.top.equalTo(closeButton.snp.bottom).offset(10)
			$0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
		}
		emailTextField.snp.makeConstraints {
			$0.top.equalTo(descriptionLabel.snp.bottom).offset(20)
			$0.leading.trailing.equalToSuperview().inset(20)
		}
		nextButton.snp.makeConstraints {
			$0.top.equalTo(emailTextField.snp.bottom).offset(20)
			$0.leading.trailing.equalToSuperview().inset(20)
			$0.height.equalTo(44)
		}
		userTextView.snp.makeConstraints {
			$0.top.equalTo(nextButton.snp.bottom).offset(20)
			$0.leading.trailing.bottom.equalToSuperview().inset(20)
		}
	}

    override func viewDidLoad() {
        super.viewDidLoad()

		title = "Регистрация"
		navigationItem.largeTitleDisplayMode = .never
    }
	
	@objc
	private func onCloseButtonTap(sender: UIButton) {
		dismiss(animated: true)
	}

	@objc
	private func onNextButtonTap(sender: UIButton) {
		guard let text = emailTextField.text else { return }
		guard !text.isEmpty else { return }
		view.endEditing(true)
		showActivityIndicator()
		userFacade.signUp(email: text) { [weak self] (result) in
			guard let self = self else { return }
			switch result {
			case let .success(model):
				self.userFacade.signIn(
					email: model.username,
					password: model.password,
					completion: { [weak self] (loginStatus) in
						guard let self = self else { return }
						self.hideActivityIndicator()
						switch loginStatus {
						case .success(_):
							self.userTextView.text = "Ваш логин: \(model.username)\nВаш пароль: \(model.password)"
							self.present(SubscriptionViewController(), animated: true)
						case let .failure(loginModel):
							self.showAlert(
								title: "Фильмикус",
								message: loginModel.errorDescription
							)
						}
					}
				)
			case let .failure(model):
				self.hideActivityIndicator()
				self.showAlert(
					title: "Фильмикус",
					message: model.message
				)
			}
			
		}
	}
}
