//
//  ReceiptStatusUpdater.swift
//  Filmikus
//
//  Created by Андрей Козлов on 21.07.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import Foundation

class ReceiptStatusUpdater {
	
	enum Keys {
		static let lastReceiptUpdate = "com.receiptStatusUpdater.lastReceiptUpdate"
	}
	
	private let storage = UserDefaults.standard
	
	private let storeKitService: StoreKitServiceType = StoreKitService.shared
	private let userFacade: UserFacadeType = UserFacade()
	
	func updateReceipt() {
		// Check if 24 hours have passed
		let today = Date()
		if let lastReceiptUpdate = storage.object(forKey: Keys.lastReceiptUpdate) as? Date {
			let dateComponents = Calendar.current.dateComponents([.hour], from: lastReceiptUpdate, to: today)
			if let diffHours = dateComponents.hour, diffHours < 24 {
				return
			}
		}
		storeKitService.loadReceipt { [weak self] (result) in
			guard let self = self else { return }
			guard let userId = self.userFacade.user?.id else { return }
			guard let receipt = try? result.get() else { return }
			self.userFacade.receipt(userId: userId, receipt: receipt) { [weak self] (model) in
				guard let self = self else { return }
				self.storage.set(today, forKey: Keys.lastReceiptUpdate)
			}
		}
	}
}
