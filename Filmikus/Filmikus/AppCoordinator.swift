//
//  AppCoordinator.swift
//  Filmikus
//
//  Created by Андрей Козлов on 27.07.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import UIKit

class AppCoordinator {
	
	private let window: UIWindow
	
	private lazy var authenticationCoordinator: AuthenticationCoordinator = {
		let controller = NavigationController()
		controller.apply(gradientStyle: .bluePurple)
		let coordinator = AuthenticationCoordinator(navigationController: controller)
		return coordinator
	}()
	
	init(window: UIWindow) {
		self.window = window
	}
	
	func start() {
		let launchVC = LaunchViewController()
		launchVC.delegate = self
		window.rootViewController = launchVC
		window.makeKeyAndVisible()
	}
	
	func setRoot(viewController: UIViewController) {
		window.rootViewController = viewController
		UIView.transition(
			with: window,
			duration: 0.4,
			options: .transitionCrossDissolve,
			animations: nil,
			completion: nil
		)
	}
	
	@objc
	private func handleUserSubscribedNotification(notification: Notification) {
		setRoot(viewController: TabBarController())
		NotificationCenter.default.removeObserver(self, name: .userDidSubscribe, object: nil)
	}
}

// MARK: - LaunchViewControllerDelegate

extension AppCoordinator: LaunchViewControllerDelegate {
	
	func launchViewController(_ viewController: LaunchViewController, didReceiveAccess type: AccessTypeModel) {
		switch type {
		case .onlyAuthorization:
			setRoot(viewController: authenticationCoordinator.navigationController)
			authenticationCoordinator.start()
			NotificationCenter.default.addObserver(
				self,
				selector: #selector(handleUserSubscribedNotification),
				name: .userDidSubscribe,
				object: nil
			)
		case .allAppWithoutContent:
			setRoot(viewController: TabBarController())
		}
	}
}
