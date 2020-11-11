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
		userFacade.updateReceipt { [weak self] (result) in
			guard let self = self else { return }
			switch result {
			case .success:
				self.storage.set(today, forKey: Keys.lastReceiptUpdate)
			case .failure:
				break
			}
		}
	}
}
