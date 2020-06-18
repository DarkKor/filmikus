//
//  UserStorage.swift
//  Filmikus
//
//  Created by Андрей Козлов on 18.06.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import Foundation

protocol UserStorageType: class {
	var user: UserModel? { get set }
	var expirationDate: Date? { get set }
}

class UserStorage: UserStorageType {
	
	enum Keys {
		static let user = "com.userStorage.user"
		static let expirationDate = "com.userStorage.expirationDate"
	}
	
	var user: UserModel? {
		get {
			guard let userData = storage.object(forKey: Keys.user) as? Data else { return nil }
			return try? decoder.decode(UserModel.self, from: userData)
		}
		set {
			let userData = try? encoder.encode(newValue)
			storage.set(userData, forKey: Keys.user)
			storage.synchronize()
		}
	}
	
	var expirationDate: Date? {
		get {
			return storage.object(forKey: Keys.expirationDate) as? Date
		}
		set {
			storage.set(newValue, forKey: Keys.expirationDate)
			storage.synchronize()
		}
	}
	
	private let storage: UserDefaults
	private let encoder: JSONEncoder = JSONEncoder()
	private let decoder: JSONDecoder = JSONDecoder()

	init(
		storage: UserDefaults = .standard
	) {
		self.storage = storage
	}

}
