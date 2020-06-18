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
	
	private let userProvider: UserProviderType = UserProvider()
	
	private lazy var loginView: LoginView = {
		let view = LoginView()
		view.delegate = self
		return view
	}()
	
	private lazy var profileView: ProfileView = {
		let view = ProfileView()
		view.delegate = self
		view.isHidden = true
		return view
	}()
	
	override func loadView() {
		view = UIView()
		view.backgroundColor = .white
		
		view.addSubview(loginView)
		view.addSubview(profileView)
		
		loginView.snp.makeConstraints {
			$0.edges.equalTo(view.safeAreaLayoutGuide)
		}
		profileView.snp.makeConstraints {
			$0.edges.equalTo(view.safeAreaLayoutGuide)
		}

	}

    override func viewDidLoad() {
        super.viewDidLoad()

		title = "Профиль"
		userProvider.isSubscribed ? profileView.hideSubscribeButtons() : profileView.showSubscribeButtons()
		 
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(handleUserSubscribedNotification),
			name: .userDidSubscribe,
			object: nil
		)
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(handleUserLoggedInNotification),
			name: .userDidLogin,
			object: nil
		)
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(handleUserLogoutNotification),
			name: .userDidLogout,
			object: nil
		)
	}
	
	@objc
	private func handleUserSubscribedNotification(notification: Notification) {
		profileView.hideSubscribeButtons()
	}
	
	@objc
	private func handleUserLoggedInNotification(notification: Notification) {
		loginView.isHidden = true
		profileView.isHidden = false
		profileView.fill(username: userProvider.user?.username ?? "")
	}
	
	@objc
	private func handleUserLogoutNotification(notification: Notification) {
		loginView.isHidden = false
		profileView.isHidden = true
	}
}

//MARK: - LoginViewDelegate

extension ProfileViewController: LoginViewDelegate {
	
	func loginViewDidSelectSignUp(_ view: LoginView) {
		let signUpVC = SignUpViewController()
		present(signUpVC, animated: true)
	}
	
	func loginViewDidSelectSignIn(_ view: LoginView) {
		let signInVC = SignInViewController()
		present(signInVC, animated: true)
	}
}

//MARK: - ProfileViewDelegate

extension ProfileViewController: ProfileViewDelegate {
	
	func profileViewDidSelectSubscribe(_ view: ProfileView) {
		let subscriptionVC = SubscriptionViewController()
		present(subscriptionVC, animated: true)
	}
	
	func profileViewDidSelectRestorePurchases(_ view: ProfileView) {
		print("restore")
	}
	
	func profileViewDidSelectLogout(_ view: ProfileView) {
		userProvider.logout()
	}
}
