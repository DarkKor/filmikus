//
//  SignUpViewController.swift
//  Filmikus
//
//  Created by Андрей Козлов on 14.05.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
	
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
	
	override func loadView() {
		view = UIView()
		view.backgroundColor = .white
		view.addSubview(descriptionLabel)
		view.addSubview(emailTextField)
		view.addSubview(nextButton)

		descriptionLabel.snp.makeConstraints {
			$0.top.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
			$0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-16)
		}
		
		emailTextField.snp.makeConstraints {
			$0.top.equalTo(descriptionLabel.snp.bottom).offset(20)
			$0.leading.equalToSuperview().offset(16)
			$0.trailing.equalToSuperview().offset(-16)
		}
		
		nextButton.snp.makeConstraints {
			$0.top.equalTo(emailTextField.snp.bottom).offset(20)
			$0.leading.equalToSuperview().offset(16)
			$0.trailing.equalToSuperview().offset(-16)
			$0.height.equalTo(44)
		}
	}

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Регистрация"
		navigationItem.largeTitleDisplayMode = .never
    }

	@objc
	private func onNextButtonTap(sender: UIButton) {
		print("NEXT")
	}
}
