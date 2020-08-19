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
    var payViewType: WelcomeTypeModel? { get }
	func signIn(email: String, password: String, completion: @escaping (SignInStatusModel) -> Void)
	func signOut()
	func signUp(email: String, completion: @escaping (SignUpStatusModel) -> Void)
	func updateReceipt(completion: @escaping (ReceiptStatusModel) -> Void)
	func welcomeType(completion: @escaping (Result<WelcomeTypeModel, Error>) -> Void)
    func setLaunchBefore()
    func setWelcomeType(type: WelcomeTypeModel)
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
    
    var payViewType: WelcomeTypeModel? {
        storage.welcomeType
    }
	
	private let service: UsersServiceType
	private let storage: UserStorageType
	private let storeKit: StoreKitServiceType
    private let provider: MoyaProvider<ValidateReceiptAPI>
	
	init(
		service: UsersServiceType = UsersService(),
		storage: UserStorageType = UserStorage(),
        storeKit: StoreKitServiceType = StoreKitService.shared,
        provider: MoyaProvider<ValidateReceiptAPI> = MoyaProvider<ValidateReceiptAPI>()
	) {
		self.service = service
		self.storage = storage
		self.storeKit = storeKit
        self.provider = provider
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
                        let expirationDates = receipts.compactMap{ $0.expirationDate }
                        guard let latestExpirationDate = expirationDates.sorted().last else {
                            self.storage.expirationDate = nil
                            return
                        }
                        self.storage.expirationDate = latestExpirationDate
                        completion(ReceiptStatusModel(userId: nil, expirationDate: latestExpirationDate))
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
		guard let welcomeType = storage.welcomeType else {
			service.welcomeType { (result) in
				completion(result)
                
			}
			return
		}
		completion(.success(welcomeType))
	}
    
    func setWelcomeType(type: WelcomeTypeModel) {
        storage.welcomeType = type
    }
    
    func setLaunchBefore() {
        storage.isLaunchedBefore = true
    }
}
