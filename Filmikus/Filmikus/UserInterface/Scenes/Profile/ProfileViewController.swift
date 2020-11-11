//
//  ProfileViewController.swift
//  Filmikus
//
//  Created by Андрей Козлов on 13.05.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import UIKit
import SnapKit

protocol ProfileViewControllerDelegate: class {
	func profileViewControllerDidSelectSignUp(_ viewController: ProfileViewController)
	func profileViewControllerDidSelectSignIn(_ viewController: ProfileViewController)
	func profileViewControllerDidSelectSubscribe(_ viewController: ProfileViewController)
}

class ProfileViewController: ViewController {
	
	weak var delegate: ProfileViewControllerDelegate?
	
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
	
	func signOut() {
		userFacade.signOut()
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
    func loginViewDidSelectRestorePurchase(_ view: LoginView) {
        showActivityIndicator()
        storeKitService.restorePurchases { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(_):
                self.userFacade.updateReceipt { [weak self] (result) in
                    guard let self = self else { return }
                    switch result {
                    case .success:
                        self.hideActivityIndicator()
                    case .failure(let error):
                        self.showAlert(message: "Возникла ошибка: \(error.localizedDescription)", completion: {
                            self.hideActivityIndicator()
                        })
                    }
                }
            case .failure(let error):
                self.showAlert(message: "Возникла ошибка: \(error.localizedDescription)", completion: {
                    self.hideActivityIndicator()
                })
            }
        }
    }
	
	func loginViewDidSelectSignUp(_ view: LoginView) {
		delegate?.profileViewControllerDidSelectSignUp(self)
	}
	
	func loginViewDidSelectSignIn(_ view: LoginView) {
		delegate?.profileViewControllerDidSelectSignIn(self)
	}
}

//MARK: - ProfileViewDelegate

extension ProfileViewController: ProfileViewDelegate {
	
	func profileViewDidSelectSubscribe(_ view: ProfileView) {
		delegate?.profileViewControllerDidSelectSubscribe(self)
	}
	
	func profileViewDidSelectRestorePurchases(_ view: ProfileView) {
		showActivityIndicator()
		storeKitService.restorePurchases { [weak self] (result) in
			guard let self = self else { return }
            switch result {
            case .success(_):
				self.userFacade.updateReceipt { (status) in
					switch status {
					case .success:
						guard self.userFacade.isSubscribed else {
							self.showAlert(
								message: "Ошибка",
								completion: { self.dismiss(animated: true) }
							)
							return
						}
						self.showAlert(
							message: "Вы успешно подписались!",
							completion: { self.dismiss(animated: true) }
						)
					case .failure(let error):
						self.showAlert(
							message: "Ошибка: \(error.localizedDescription)",
							completion: { self.dismiss(animated: true) }
						)
					}
					
				}
            case .failure(let error):
                self.showAlert(message: "Возникла ошибка: \(error.localizedDescription)", completion: {
                    self.hideActivityIndicator()
                })
            }
		}
	}
	
	func profileViewDidSelectLogout(_ view: ProfileView) {
		userFacade.signOut()
	}
}
