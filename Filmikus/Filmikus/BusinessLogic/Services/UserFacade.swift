//
//  UserFacade.swift
//  Filmikus
//
//  Created by Андрей Козлов on 18.06.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import Foundation
import Moya

extension Notification.Name {
	static let userDidLogin = Notification.Name(rawValue: "userDidLogin")
	static let userDidLogout = Notification.Name(rawValue: "userDidLogout")
}

protocol UserFacadeType {
	var user: UserModel? { get }
	var expirationDate: Date? { get }
	var isSubscribed: Bool { get }
	var isSignedIn: Bool { get }
    var isLaunchedBefore: Bool { get }
	func signIn(email: String, password: String, completion: @escaping (SignInStatusModel) -> Void)
	func signOut()
	func signUp(email: String, completion: @escaping (SignUpStatusModel) -> Void)
	func updateReceipt(completion: @escaping (ReceiptStatusModel) -> Void)
	func welcomeType(completion: @escaping (Result<WelcomeTypeModel, Error>) -> Void)
    func setLaunchBefore()
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
    
    var isLaunchedBefore: Bool {
        storage.isLaunchedBefore
    }
	
	private let service: UsersServiceType
	private let storage: UserStorageType
	private let storeKit: StoreKitServiceType
    private let provider = MoyaProvider<ValidateReceiptAPI>()
	
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
        storeKit.loadReceipt { (result) in
            guard let receipt = try? result.get() else { return }
            if let userId = self.user?.id {
                self.service.updateReceipt(userId: userId, receipt: receipt) { [weak self] result in
                    guard let self = self else { return }
                    guard let status = try? result.get() else { return }
                    self.storage.expirationDate = status.expirationDate
                    completion(status)
                    guard self.isSubscribed else { return }
                    NotificationCenter.default.post(name: .userDidSubscribe, object: nil)
                }
            } else {
                self.provider.request(.validate(receipt: receipt)) { result in
                    switch result {
                    case let .success(response):
                        guard let receipts = try? JSONDecoder().decode(ReceiptsModel.self, from: response.data).receipts else { return }
                        let dates = receipts.compactMap{ $0.expirationDate }
                        guard let expirationDate = dates.sorted().last else { return }
                        self.storage.expirationDate = expirationDate
                        completion(ReceiptStatusModel(userId: nil, expirationDate: expirationDate))
                        guard self.isSubscribed else { return }
                        NotificationCenter.default.post(name: .userDidSubscribe, object: nil)
                    default:
                        break
                    }
                }
            }
        }
    }
	
	func welcomeType(completion: @escaping (Result<WelcomeTypeModel, Error>) -> Void) {
		guard let accessType = storage.accessType else {
			service.accessType { (result) in
				completion(result)
			}
			return
		}
		completion(.success(accessType))
	}
    
    func setLaunchBefore() {
        storage.isLaunchedBefore = true
    }
}
