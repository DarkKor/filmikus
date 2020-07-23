//
//  ProfileViewController.swift
//  Filmikus
//
//  Created by Андрей Козлов on 13.05.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import UIKit
import SnapKit

class ProfileViewController: ViewController {
	
	private let userFacade: UserFacadeType = UserFacade()
	
	private let storeKitService: StoreKitServiceType = StoreKitService.shared
	
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
	
	deinit {
		NotificationCenter.default.removeObserver(self)
	}
	
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
		
		updateUI()
		
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
	
	private func updateUI() {
		loginView.isHidden = userFacade.isSignedIn
		profileView.isHidden = !userFacade.isSignedIn
		profileView.fill(
			username: userFacade.user?.username ?? "",
			isSubscribed: userFacade.isSubscribed,
			expirationDate: userFacade.expirationDate
		)
	}
	
	@objc
	private func handleUserSubscribedNotification(notification: Notification) {
		updateUI()
	}
	
	@objc
	private func handleUserLoggedInNotification(notification: Notification) {
		updateUI()
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
		showActivityIndicator()
		storeKitService.restorePurchases { [weak self] (result) in
			guard let self = self else { return }
			self.userFacade.updateReceipt { [weak self] (model) in
				guard let self = self else { return }
				self.hideActivityIndicator()
			}
		}
	}
	
	func profileViewDidSelectLogout(_ view: ProfileView) {
		userFacade.signOut()
	}
}
