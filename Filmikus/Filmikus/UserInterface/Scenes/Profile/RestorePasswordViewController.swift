//
//  RestorePasswordViewController.swift
//  Filmikus
//
//  Created by Алесей Гущин on 19.08.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import UIKit

protocol RestorePasswordViewControllerDelegate: class {
    func restorePasswordViewControllerDidSelectClose(_ viewController: RestorePasswordViewController)
    func restorePasswordViewController(_ viewController: RestorePasswordViewController, didRestorePasswordWithPaidStatus isPaid: Bool)
}

class RestorePasswordViewController: ViewController {
    
    weak var delegate: RestorePasswordViewControllerDelegate?
    
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
    
    private lazy var loginTextField: UnderlinedTextField = {
        let textField = UnderlinedTextField(placeholder: "Введите email")
        textField.textContentType = .nickname
        textField.delegate = self
        return textField
    }()
    private lazy var passwordTextField: PasswordUnderlinedTextField = {
        let textField = PasswordUnderlinedTextField(placeholder: "Введите новый пароль")
        textField.delegate = self
        return textField
    }()
    
    private lazy var signInButton = BlueBorderButton(title: "Восстановить пароль", target: self, action: #selector(onRestorePasswordButtonTap))
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        scrollView.keyboardDismissMode = .interactive
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        
        containerView.addSubview(closeButton)
        containerView.addSubview(loginTextField)
        containerView.addSubview(passwordTextField)
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
        
        loginTextField.snp.makeConstraints {
            $0.top.equalTo(closeButton.snp.bottom).offset(40)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        passwordTextField.snp.makeConstraints {
            $0.top.equalTo(loginTextField.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        signInButton.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).offset(20)
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
        delegate?.restorePasswordViewControllerDidSelectClose(self)
    }
    
    @objc
    private func onRestorePasswordButtonTap(sender: UIButton) {
        view.endEditing(true)
        guard let username = self.loginTextField.text, !username.isEmpty else { return }
        guard let password = self.passwordTextField.text, !password.isEmpty else { return }
        showActivityIndicator()
        userFacade.restorePassword(email: username, password: password) { [weak self] (restoreStatus) in
            guard let self = self else { return }
            switch restoreStatus {
            case .success(_):
                self.userFacade.updateReceipt { [weak self] (subcriptionStatus) in
                    guard let self = self else { return }
                    self.hideActivityIndicator()
                    var isPaid = false
                    guard let expirationDate = subcriptionStatus.expirationDate else {
                        self.delegate?.restorePasswordViewController(self, didRestorePasswordWithPaidStatus: isPaid)
                        return
                    }
                    isPaid = expirationDate > Date()
                    self.delegate?.restorePasswordViewController(self, didRestorePasswordWithPaidStatus: isPaid)
                }
            case let .failure(model):
                self.showAlert(message: model.message)
            }
        }
    }
}

// MARK: - UITextFieldDelegate

extension RestorePasswordViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
