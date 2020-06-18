//
//  UserProvider.swift
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

protocol UserProviderType {
	var user: UserModel? { get }
	var isSubscribed: Bool { get }
	var isLoggedIn: Bool { get }
	func login(userModel: UserModel)
	func logout()
	func register(email: String, completion: @escaping (Result<UserResponseModel, Error>) -> Void)
}

class UserProvider: UserProviderType {
	
	var user: UserModel? {
		storage.user
	}
	
	var isSubscribed: Bool {
		storage.expirationDate.map { $0 > Date() } ?? false
	}
	
	var isLoggedIn: Bool {
		storage.user != nil
	}
	
	private let service: UsersServiceType
	private let storage: UserStorageType
	
	init(
		service: UsersServiceType = UsersService(),
		storage: UserStorageType = UserStorage()
	) {
		self.service = service
		self.storage = storage
	}
	
	func login(userModel: UserModel) {
		storage.user = userModel
		NotificationCenter.default.post(name: .userDidLogin, object: nil)
	}
	
	func logout() {
		storage.user = nil
		NotificationCenter.default.post(name: .userDidLogout, object: nil)
	}
	
	func register(email: String, completion: @escaping (Result<UserResponseModel, Error>) -> Void) {
		service.register(email: email, completion: completion)
	}
}
