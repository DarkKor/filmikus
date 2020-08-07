//
//  AuthenticationCoordinator.swift
//  Filmikus
//
//  Created by Андрей Козлов on 28.07.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

//import UIKit
//
//class AuthenticationCoordinator {
//	
//	var onFinishFlow: (() -> Void)?
//	
//	let navigationController: UINavigationController
//	
//	init(navigationController: UINavigationController) {
//		self.navigationController = navigationController
//	}
//	
//	func start() {
//		let profileVC = ProfileViewController()
//		profileVC.delegate = self
//		navigationController.setViewControllers([profileVC], animated: true)
//	}
//}
//
//// MARK: - ProfileViewControllerDelegate
//
//extension AuthenticationCoordinator: ProfileViewControllerDelegate {
//	func profileViewControllerDidSelectSignUp(_ viewController: ProfileViewController) {
//		let signUpVC = SignUpViewController()
//		signUpVC.delegate = self
//		navigationController.present(signUpVC, animated: true)
//	}
//	
//	func profileViewControllerDidSelectSignIn(_ viewController: ProfileViewController) {
//		let signInVC = SignInViewController()
//		signInVC.delegate = self
//		navigationController.present(signInVC, animated: true)
//	}
//	
//	func profileViewControllerDidSelectSubscribe(_ viewController: ProfileViewController) {
//		let subscriptionVC = SubscriptionViewController()
//		subscriptionVC.onClose = {
//			viewController.dismiss(animated: true)
//		}
//		navigationController.present(subscriptionVC, animated: true)
//	}
//}
//
//// MARK: - SignUpViewControllerDelegate
//
//extension AuthenticationCoordinator: SignUpViewControllerDelegate {
//	
//	func signUpViewControllerDidSelectClose(_ viewController: SignUpViewController) {
//		navigationController.dismiss(animated: true)
//	}
//	
//	func signUpViewControllerDidSignUp(_ viewController: SignUpViewController) {
//		let subscriptionVC = SubscriptionViewController()
//		subscriptionVC.onClose = {
//			viewController.dismiss(animated: true)
//			viewController.showAlert(message: "Чтобы пользоваться приложением необходимо купить подписку")
//		}
//		viewController.present(subscriptionVC, animated: true)
//	}
//}
//
//// MARK: - SignInViewControllerDelegate
//
//extension AuthenticationCoordinator: SignInViewControllerDelegate {
//	
//	func signInViewControllerDidSelectClose(_ viewController: SignInViewController) {
//		navigationController.dismiss(animated: true)
//	}
//	
//	func signInViewController(_ viewController: SignInViewController, didSignInWithPaidStatus isPaid: Bool) {
//		guard !isPaid else { return }
//		let subscriptionVC = SubscriptionViewController()
//		subscriptionVC.onClose = {
//			viewController.dismiss(animated: true)
//			self.navigationController.dismiss(animated: true)
//		}
//		viewController.present(subscriptionVC, animated: true)
//	}
//}
