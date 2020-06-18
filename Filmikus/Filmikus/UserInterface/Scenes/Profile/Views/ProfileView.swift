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
	func profileViewDidSelectLogout(_ view: ProfileView)
}

class ProfileView: UIView {
	
	weak var delegate: ProfileViewDelegate?
	
	private lazy var stackView: UIStackView = {
		let stack = UIStackView(arrangedSubviews: [
			usernameLabel, subscribeButton, restorePurchasesButton, logoutButton
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
	
	private lazy var subscribeButton = BlueButton(title: "ПОДПИСАТЬСЯ", target: self, action: #selector(onSubscribeButtonTap))
	private lazy var restorePurchasesButton = BlueButton(title: "ВОССТАНОВИТЬ ПОКУПКИ", target: self, action: #selector(onRestorePurchasesButtonTap))
	private lazy var logoutButton = BlueBorderButton(title: "ВЫЙТИ", target: self, action: #selector(onLogoutButtonTap))

	init() {
		super.init(frame: .zero)
		addSubview(stackView)
		stackView.snp.makeConstraints {
			$0.edges.equalToSuperview().inset(20)
		}
		
		logoutButton.snp.makeConstraints {
			$0.height.equalTo(44)
		}
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func fill(username: String) {
		usernameLabel.text = username
	}
	
	func showSubscribeButtons() {
		subscribeButton.isHidden = false
		restorePurchasesButton.isHidden = false
	}
	
	func hideSubscribeButtons() {
		subscribeButton.isHidden = true
		restorePurchasesButton.isHidden = true
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
	private func onLogoutButtonTap(sender: UIButton) {
		delegate?.profileViewDidSelectLogout(self)
	}
}
