//
//  StoreKitService.swift
//  Filmikus
//
//  Created by Андрей Козлов on 19.05.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import StoreKit

class StoreKitService: NSObject {
	
	typealias SubscriptionBlock = (Result<Void, Error>) -> Void
	typealias ProductsBlock = (Result<[SKProduct], Error>) -> Void
	
	private var subscriptionBlock: SubscriptionBlock?
	private var refreshSubscriptionBlock: SubscriptionBlock?
	private var productsBlock: ProductsBlock?
	
	private var sharedSecret = ""
	
	private(set) var products: [SKProduct] = []

	static let shared = StoreKitService()
	
	private override init() {
		super.init()
		SKPaymentQueue.default().add(self)
	}
	
	// MARK:- Main methods
	
	func startWith(productIds: Set<String>, sharedSecret: String) {
		self.sharedSecret = sharedSecret
		loadProducts(with: productIds)
	}
	
	func expirationDate(for identifier: String) -> Date? {
		UserDefaults.standard.object(forKey: identifier) as? Date
	}
	
	func purchase(product: SKProduct, completion: SubscriptionBlock? = nil) {
		guard SKPaymentQueue.canMakePayments() else { return }
		guard SKPaymentQueue.default().transactions.last?.transactionState != .purchasing else { return }
		subscriptionBlock = completion
		let payment = SKPayment(product: product)
		SKPaymentQueue.default().add(payment)
	}
	
	func restorePurchases(completion: SubscriptionBlock? = nil) {
		subscriptionBlock = completion
		SKPaymentQueue.default().restoreCompletedTransactions()
	}
	/*
	It's the most simple way to send verify receipt request. You shouldn't use current code in production apps.
	This code doesn't handle errors.
	*/
	func refreshSubscriptionsStatus(completion: SubscriptionBlock? = nil) {
		self.refreshSubscriptionBlock = completion
		guard let receiptUrl = Bundle.main.appStoreReceiptURL else {
			refreshReceipt()
			// do not call block in this case. It will be called inside after receipt refreshing finishes.
			return
		}
		#if DEBUG
		let urlString = "https://sandbox.itunes.apple.com/verifyReceipt"
		#else
		let urlString = "https://buy.itunes.apple.com/verifyReceipt"
		#endif
		let receiptData = try? Data(contentsOf: receiptUrl).base64EncodedString()
		let requestData: [String: Any] = [
			"receipt-data": receiptData ?? "",
			"password" : self.sharedSecret,
			"exclude-old-transactions": true
		]
		var request = URLRequest(url: URL(string: urlString)!)
		request.httpMethod = "POST"
		request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
		let httpBody = try? JSONSerialization.data(withJSONObject: requestData, options: [])
		request.httpBody = httpBody
		URLSession.shared.dataTask(with: request)  { (data, response, error) in
			DispatchQueue.main.async {
				if let error = error {
					self.refreshSubscriptionBlock?(.failure(error))
					self.refreshSubscriptionBlock = nil
					return
				}
				guard let data = data,
					let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
					let error = NSError(domain: "error validating receipt", code: 0, userInfo: nil)
					self.refreshSubscriptionBlock?(.failure(error))
					self.refreshSubscriptionBlock = nil
					return
				}
				self.parseReceipt(json: json)
			}
		}.resume()
	}
	/*
	It's the most simple way to get latest expiration date. You shouldn't use current code in production apps.
	This code doesn't handle errors or some situations like cancellation date.
	*/
	private func parseReceipt(json: [String: Any]) {
		guard let receipts = json["latest_receipt_info"] as? [[String: Any]] else {
			self.refreshSubscriptionBlock?(.failure(NSError()))
			self.refreshSubscriptionBlock = nil
			return
		}
		let formatter = DateFormatter()
		formatter.dateFormat = "yyyy-MM-dd HH:mm:ss VV"
		for receipt in receipts {
			let productID = receipt["product_id"] as! String
			let today = Date()
			if let expiresDate = formatter.date(from: receipt["expires_date"] as! String), expiresDate > today {
				// do not save expired date to user defaults to avoid overwriting with expired date
				UserDefaults.standard.set(expiresDate, forKey: productID)
			}
		}
		self.refreshSubscriptionBlock?(.success(()))
		self.refreshSubscriptionBlock = nil
	}
	/*
	Should not be called directly. Call refreshSubscriptionsStatus instead.
	*/
	private func refreshReceipt() {
		let request = SKReceiptRefreshRequest(receiptProperties: nil)
		request.delegate = self
		request.start()
	}
	
	private func loadProducts(with productIds: Set<String>) {
		let request = SKProductsRequest(productIdentifiers: productIds)
		request.delegate = self
		request.start()
	}
	
	private func loadProducts(with productIds: Set<String>, completion: ProductsBlock? = nil) {
		let request = SKProductsRequest(productIdentifiers: productIds)
		productsBlock = completion
		request.delegate = self
		request.start()
	}
}

// MARK: - SKRequestDelegate

extension StoreKitService: SKRequestDelegate {
	
	func requestDidFinish(_ request: SKRequest) {
		guard request is SKReceiptRefreshRequest else { return }
		refreshSubscriptionsStatus(completion: subscriptionBlock)
	}
	
	func request(_ request: SKRequest, didFailWithError error: Error){
		guard request is SKReceiptRefreshRequest else { return }
		refreshSubscriptionBlock?(.failure(error))
		refreshSubscriptionBlock = nil
	}
}

// MARK: - SKProductsRequestDelegate

extension StoreKitService: SKProductsRequestDelegate {
	
	public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
		products = response.products
		productsBlock?(.success(response.products))
	}
}

// MARK: - SKPaymentTransactionObserver

extension StoreKitService: SKPaymentTransactionObserver {
	
	public func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
		for transaction in transactions {
			switch (transaction.transactionState) {
			case .purchased, .restored:
				SKPaymentQueue.default().finishTransaction(transaction)
				refreshSubscriptionsStatus { result in
					self.subscriptionBlock?(result)
					self.subscriptionBlock = nil
				}
			case .failed:
				SKPaymentQueue.default().finishTransaction(transaction)
				print("purchase error : \(transaction.error?.localizedDescription ?? "")")
				subscriptionBlock?(.failure(transaction.error ?? NSError()))
				subscriptionBlock = nil
			case .deferred, .purchasing:
				break
			default:
				break
			}
		}
	}
}
