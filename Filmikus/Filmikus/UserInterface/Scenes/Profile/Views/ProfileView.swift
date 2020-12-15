//
//  ProfileView.swift
//  Filmikus
//
//  Created by Андрей Козлов on 17.06.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import UIKit

protocol ProfileViewDelegate: class {
	func profileViewDidSelectSubscribe(_ view: ProfileView)
	func profileViewDidSelectRestorePurchases(_ view: ProfileView)
	func profileViewDidSelectChangePasssword(_ view: ProfileView)
    func profileViewDidSelectLogout(_ view: ProfileView)
}

class ProfileView: UIView {
	
	weak var delegate: ProfileViewDelegate?
	
	private lazy var stackView: UIStackView = {
		let stack = UIStackView(arrangedSubviews: [
			usernameLabel, userStatusLabel, subscribeButton, restorePurchasesButton, changePasswordButton, logoutButton
		])
		stack.axis = .vertical
		stack.spacing = 20
		return stack
	}()

	private lazy var usernameLabel: UILabel = {
		let label = UILabel()
		label.font = .boldSystemFont(ofSize: 20)
		return label
	}()
	
	private lazy var userStatusLabel: UILabel = {
		let label = UILabel()
		label.numberOfLines = 0
		label.font = .systemFont(ofSize: 20)
		return label
	}()
	
	private lazy var subscribeButton = BlueButton(title: "ПОДПИСАТЬСЯ", target: self, action: #selector(onSubscribeButtonTap))
	private lazy var restorePurchasesButton = BlueButton(title: "ВОССТАНОВИТЬ ПОКУПКИ", target: self, action: #selector(onRestorePurchasesButtonTap))
    private lazy var changePasswordButton = BlueButton(title: "СМЕНИТЬ ПАРОЛЬ", target: self, action: #selector(onChangePasswordButtonTap))
	private lazy var logoutButton = BlueBorderButton(title: "ВЫЙТИ", target: self, action: #selector(onLogoutButtonTap))

	init() {
		super.init(frame: .zero)
		addSubview(stackView)
//		stackView.snp.makeConstraints {
//			$0.edges.equalToSuperview().inset(20)
//		}
		stackView.snp.makeConstraints {
			$0.center.equalToSuperview()
			$0.leading.trailing.equalToSuperview().inset(20)
		}
		
		logoutButton.snp.makeConstraints {
			$0.height.equalTo(44)
		}
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func fill(username: String, isSubscribed: Bool, expirationDate: Date?) {
		usernameLabel.text = username
		subscribeButton.isHidden = isSubscribed
		restorePurchasesButton.isHidden = isSubscribed
		var userStatusText = isSubscribed ? "Подписка активна" : "Нет доступа к контенту. Для получения доступа - нажмите кнопку 'Подписаться'"
        if isSubscribed, let expirationDate = expirationDate {
            if expirationDate.compare(Date()) == .orderedDescending {
                let formatter = DateFormatter()
                formatter.dateFormat = "dd.MM.yyyy"
                userStatusText += " до \(formatter.string(from: expirationDate))"
            }
		}
		userStatusLabel.text = userStatusText
	}
	
	@objc
	private func onSubscribeButtonTap(sender: UIButton) {
		delegate?.profileViewDidSelectSubscribe(self)
	}

	@objc
	private func onRestorePurchasesButtonTap(sender: UIButton) {
		delegate?.profileViewDidSelectRestorePurchases(self)
	}
    
    @objc
    private func onChangePasswordButtonTap(sender: UIButton) {
        delegate?.profileViewDidSelectChangePasssword(self)
    }
	
	@objc
	private func onLogoutButtonTap(sender: UIButton) {
		delegate?.profileViewDidSelectLogout(self)
	}
}
