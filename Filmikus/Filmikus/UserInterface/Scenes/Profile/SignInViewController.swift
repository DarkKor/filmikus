//
//  SignInViewController.swift
//  Filmikus
//
//  Created by Андрей Козлов on 16.06.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import UIKit

protocol SignInViewControllerDelegate: class {
	func signInViewControllerDidSelectClose(_ viewController: SignInViewController)
	func signInViewController(_ viewController: SignInViewController, didSignInWithPaidStatus isPaid: Bool)
}

class SignInViewController: ViewController {
	
	weak var delegate: SignInViewControllerDelegate?
	
	private let userFacade: UserFacadeType = UserFacade()
		
	private lazy var scrollView = UIScrollView()
	private lazy var containerView = UIView()
	
	private lazy var closeButton: UIButton = {
		let button = UIButton()
		button.tintColor = .appBlue
		button.setImage(UIImage(systemName: "xmark"), for: .normal)
		button.addTarget(self, action: #selector(onCloseButtonTap), for: .touchUpInside)
		return button
	}()
	
	private lazy var segmentControl: UnderlinedSegmentControl = {
		let segment = UnderlinedSegmentControl(segments: [
			"По логину", "По номеру телефона"
		])
		segment.addTarget(self, action: #selector(segmentControlChanged), for: .valueChanged)
		return segment
	}()
	
	private lazy var loginTextField: UnderlinedTextField = {
		let textField = UnderlinedTextField(placeholder: "Введите логин")
		textField.textContentType = .emailAddress
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
		textField.delegate = self
		return textField
	}()
	private lazy var passwordTextField: PasswordUnderlinedTextField = {
		let textField = PasswordUnderlinedTextField(placeholder: "Введите пароль")
        textField.isSecureTextEntry = true
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
		textField.delegate = self
		return textField
	}()
	private lazy var phoneTextField: UnderlinedTextField = {
		let textField = UnderlinedTextField(placeholder: "Введите номер телефона")
		textField.delegate = self
		textField.keyboardType = .phonePad
		textField.textContentType = .telephoneNumber
		textField.isHidden = true
		return textField
	}()
	
    private lazy var restorePasswordButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .regular)
        button.setTitle("Забыли пароль?", for: .normal)
        button.setTitleColor(.appBlue, for: .normal)
        button.addTarget(self, action: #selector(onRestorePasswordButtonTap), for: .touchUpInside)
        return button
    }()
	private lazy var signInButton = BlueBorderButton(title: "ВОЙТИ", target: self, action: #selector(onSignInButtonTap))
	
	override func loadView() {
		view = UIView()
		view.backgroundColor = .white
		scrollView.keyboardDismissMode = .interactive
		view.addSubview(scrollView)
		scrollView.addSubview(containerView)
		
		containerView.addSubview(closeButton)
		containerView.addSubview(segmentControl)
		containerView.addSubview(loginTextField)
		containerView.addSubview(passwordTextField)
		containerView.addSubview(phoneTextField)
        containerView.addSubview(restorePasswordButton)
		containerView.addSubview(signInButton)
		
		scrollView.translatesAutoresizingMaskIntoConstraints = false
		let frameGuide = scrollView.frameLayoutGuide
		let contentGuide = scrollView.contentLayoutGuide
		
		frameGuide.snp.makeConstraints {
			$0.edges.equalTo(view)
			$0.width.equalTo(contentGuide)
		}
		containerView.snp.makeConstraints {
			$0.edges.equalTo(contentGuide)
		}
		
		closeButton.snp.makeConstraints {
			$0.top.right.equalTo(containerView.safeAreaLayoutGuide).inset(20)
		}
		
		segmentControl.snp.makeConstraints {
			$0.top.equalTo(closeButton.snp.bottom).offset(10)
			$0.leading.trailing.equalToSuperview().inset(0)
		}
		
		loginTextField.snp.makeConstraints {
			$0.top.equalTo(segmentControl.snp.bottom).offset(40)
			$0.leading.trailing.equalToSuperview().inset(20)
		}
		passwordTextField.snp.makeConstraints {
			$0.top.equalTo(loginTextField.snp.bottom).offset(20)
			$0.leading.trailing.equalToSuperview().inset(20)
		}
		phoneTextField.snp.makeConstraints {
			$0.top.equalTo(segmentControl.snp.bottom).offset(40)
			$0.leading.trailing.equalToSuperview().inset(20)
		}
        restorePasswordButton.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).offset(5)
            $0.leading.equalToSuperview().inset(20)
        }
		signInButton.snp.makeConstraints {
			$0.top.equalTo(restorePasswordButton.snp.bottom).offset(15)
			$0.centerX.bottom.equalToSuperview()
			$0.height.equalTo(44)
			if traitCollection.userInterfaceIdiom == .pad {
				$0.width.equalToSuperview().dividedBy(2)
			} else {
				$0.width.equalToSuperview().inset(20)
			}
		}
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(keyboardWillShow),
			name: UIResponder.keyboardWillShowNotification,
			object: nil
		)
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(keyboardWillHide),
			name: UIResponder.keyboardWillHideNotification,
			object: nil
		)
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		NotificationCenter.default.removeObserver(self)
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesBegan(touches, with: event)
		
		view.endEditing(true)
	}
	
	@objc
	private func keyboardWillShow(notification: Notification) {
		guard let userInfo = notification.userInfo else { return }
		guard let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
		scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height, right: 0)
	}
	
	@objc
	private func keyboardWillHide(notification: Notification) {
		scrollView.contentInset = .zero
	}
	
	@objc
	private func onCloseButtonTap(sender: UIButton) {
		delegate?.signInViewControllerDidSelectClose(self)
	}
	
	@objc
	private func segmentControlChanged(sender: UnderlinedSegmentControl) {
		let isLoginAuth = sender.selectedIndex == 0
		self.loginTextField.isHidden = !isLoginAuth
		self.passwordTextField.isHidden = !isLoginAuth
		self.phoneTextField.isHidden = isLoginAuth
	}
	
	@objc
	private func onSignInButtonTap(sender: UIButton) {
		view.endEditing(true)
        
        if !self.loginTextField.isHidden {
            loginViaEmail()
        } else {
            loginViaPhone()
        }
	}
    
    private func loginViaEmail() {
        var validated = true
        if self.loginTextField.text == nil || self.loginTextField.text!.isEmpty {
            self.loginTextField.shake()
            validated = false
        }
        if self.passwordTextField.text == nil || self.passwordTextField.text!.isEmpty {
            self.passwordTextField.shake()
            validated = false
        }
        
        if !validated {
            return
        }
        
        let username = self.loginTextField.text!
        let password = self.passwordTextField.text!

        showActivityIndicator()
        self.userFacade.signIn(email: username, password: password) { [weak self] (loginStatus) in
            guard let self = self else { return }
            self.hideActivityIndicator()
            switch loginStatus {
            case .success(_):
                let isPaid = self.userFacade.isSubscribed
                self.delegate?.signInViewController(self, didSignInWithPaidStatus: isPaid)
                guard isPaid else { return }
                self.userFacade.updateReceipt(completion: { _ in })
            case let .failure(model):
                self.showAlert(message: model.errorDescription)
            }
        }
    }
    
    private func loginViaPhone() {
        guard let phone = self.phoneTextField.text, !phone.isEmpty else {
            self.phoneTextField.shake()
            return
        }

        showActivityIndicator()
        self.userFacade.signIn(phone: phone) { [weak self] (loginStatus) in
            guard let self = self else { return }
            self.hideActivityIndicator()
            switch loginStatus {
            case .success(_):
                let isPaid = self.userFacade.isSubscribed
                self.delegate?.signInViewController(self, didSignInWithPaidStatus: isPaid)
                guard isPaid else { return }
                self.userFacade.updateReceipt(completion: { _ in })
            case let .failure(model):
                self.showAlert(message: model.errorDescription)
            }
        }
    }
    
    @objc
    private func onRestorePasswordButtonTap(sender: UIButton) {
        let restorePasswordVC = RestorePasswordViewController()
        restorePasswordVC.delegate = self
        present(restorePasswordVC, animated: true)
    }
}

// MARK: - UITextFieldDelegate

extension SignInViewController: UITextFieldDelegate {
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
}

// MARK: - RestorePasswordViewControllerDelegate

extension SignInViewController: RestorePasswordViewControllerDelegate {
    func restorePasswordViewControllerDidSelectClose(_ viewController: RestorePasswordViewController) {
        viewController.dismiss(animated: true)
    }
    
    func restorePasswordViewController(_ viewController: RestorePasswordViewController, didRestorePasswordWithPaidStatus isPaid: Bool) {
        viewController.dismiss(animated: true)
        delegate?.signInViewController(self, didSignInWithPaidStatus: isPaid)
    }
}
