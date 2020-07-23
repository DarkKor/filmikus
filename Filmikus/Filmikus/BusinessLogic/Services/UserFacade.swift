//
//  UserFacade.swift
//  Filmikus
//
//  Created by Андрей Козлов on 18.06.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import Foundation

extension Notification.Name {
	static let userDidLogin = Notification.Name(rawValue: "userDidLogin")
	static let userDidLogout = Notification.Name(rawValue: "userDidLogout")
}

protocol UserFacadeType {
	var user: UserModel? { get }
	var expirationDate: Date? { get }
	var isSubscribed: Bool { get }
	var isSignedIn: Bool { get }
	func signIn(email: String, password: String, completion: @escaping (SignInStatusModel) -> Void)
	func signOut()
	func signUp(email: String, completion: @escaping (SignUpStatusModel) -> Void)
	func updateReceipt(completion: @escaping (ReceiptStatusModel) -> Void)
}

class UserFacade: UserFacadeType {
	
	var user: UserModel? {
		storage.user
	}
	
	var expirationDate: Date? {
		storage.expirationDate
	}
	
	var isSubscribed: Bool {
		storage.expirationDate.map { $0 > Date() } ?? false
	}
	
	var isSignedIn: Bool {
		storage.user != nil
	}
	
	private let service: UsersServiceType
	private let storage: UserStorageType
	private let storeKit: StoreKitServiceType
	
	init(
		service: UsersServiceType = UsersService(),
		storage: UserStorageType = UserStorage(),
		storeKit: StoreKitServiceType = StoreKitService.shared
	) {
		self.service = service
		self.storage = storage
		self.storeKit = storeKit
	}
	
	func signIn(email: String, password: String, completion: @escaping (SignInStatusModel) -> Void) {
		service.login(email: email, password: password) { [weak self] (result) in
			guard let self = self else { return }
			guard let userStatus = try? result.get() else { return }
			switch userStatus {
			case let .success(model):
				self.storage.user = UserModel(id: model.userId, username: email, password: password)
				NotificationCenter.default.post(name: .userDidLogin, object: nil)
			case .failure(_):
				break
			}
			completion(userStatus)
		}
	}
	
	func signOut() {
		storage.user = nil
		storage.expirationDate = nil
		NotificationCenter.default.post(name: .userDidLogout, object: nil)
	}
	
	func signUp(email: String, completion: @escaping (SignUpStatusModel) -> Void) {
		service.register(email: email) { result in
			guard let status = try? result.get() else { return }
			completion(status)
		}
	}
	
	func updateReceipt(completion: @escaping (ReceiptStatusModel) -> Void) {
		guard let userId = user?.id else { return }
		storeKit.loadReceipt { (result) in
			guard let receipt = try? result.get() else { return }
			self.service.updateReceipt(userId: userId, receipt: receipt) { [weak self] result in
				guard let self = self else { return }
				guard let status = try? result.get() else { return }
				self.storage.expirationDate = status.expirationDate
				completion(status)
				guard self.isSubscribed else { return }
				NotificationCenter.default.post(name: .userDidSubscribe, object: nil)
			}
		}
	}
}
