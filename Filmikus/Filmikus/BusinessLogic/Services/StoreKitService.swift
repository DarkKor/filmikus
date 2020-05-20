//
//  StoreKitService.swift
//  Filmikus
//
//  Created by Андрей Козлов on 19.05.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import StoreKit

extension Notification.Name {
	static let storeKitProductsDidLoad = Notification.Name("storeKitProductsDidLoad")
}

class StoreKitService: NSObject {
	
	public typealias SuccessBlock = () -> Void
	public typealias FailureBlock = (Error?) -> Void
	
	private var successBlock: SuccessBlock?
	private var failureBlock: FailureBlock?
	
	private var refreshSubscriptionSuccessBlock: SuccessBlock?
	private var refreshSubscriptionFailureBlock: FailureBlock?
	
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
	
	func purchase(product: SKProduct, success: @escaping SuccessBlock, failure: @escaping FailureBlock) {
		guard SKPaymentQueue.canMakePayments() else { return }
		guard SKPaymentQueue.default().transactions.last?.transactionState != .purchasing else { return }
		self.successBlock = success
		self.failureBlock = failure
		let payment = SKPayment(product: product)
		SKPaymentQueue.default().add(payment)
	}
	
	func restorePurchases(success: @escaping SuccessBlock, failure: @escaping FailureBlock) {
		self.successBlock = success
		self.failureBlock = failure
		SKPaymentQueue.default().restoreCompletedTransactions()
	}
	/* It's the most simple way to send verify receipt request. Consider this code as for learning purposes. You shouldn't use current code in production apps.
	This code doesn't handle errors.
	*/
	func refreshSubscriptionsStatus(success: @escaping SuccessBlock, failure: @escaping FailureBlock) {
		self.refreshSubscriptionSuccessBlock = success
		self.refreshSubscriptionFailureBlock = failure
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
				guard let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) else {
					print("error validating receipt: \(error?.localizedDescription ?? "")")
					self.refreshSubscriptionFailureBlock?(error)
					self.cleanUpRefeshReceiptBlocks()
					return
				}
				self.parseReceipt(json as! [String: Any])
			}
		}.resume()
	}
	/* It's the most simple way to get latest expiration date. Consider this code as for learning purposes. You shouldn't use current code in production apps.
	This code doesn't handle errors or some situations like cancellation date.
	*/
	private func parseReceipt(_ json: [String: Any]) {
		guard let receipts = json["latest_receipt_info"] as? [[String: Any]] else {
			self.refreshSubscriptionFailureBlock?(nil)
			self.cleanUpRefeshReceiptBlocks()
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
		self.refreshSubscriptionSuccessBlock?()
		self.cleanUpRefeshReceiptBlocks()
	}
	/*
	Private method. Should not be called directly. Call refreshSubscriptionsStatus instead.
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
	
	private func cleanUpRefeshReceiptBlocks() {
		self.refreshSubscriptionSuccessBlock = nil
		self.refreshSubscriptionFailureBlock = nil
	}
}

// MARK: - SKRequestDelegate

extension StoreKitService: SKRequestDelegate {
	
	func requestDidFinish(_ request: SKRequest) {
		if request is SKReceiptRefreshRequest {
			refreshSubscriptionsStatus(success: self.successBlock ?? {}, failure: self.failureBlock ?? {_ in})
		}
	}
	
	func request(_ request: SKRequest, didFailWithError error: Error){
		if request is SKReceiptRefreshRequest {
			self.refreshSubscriptionFailureBlock?(error)
			self.cleanUpRefeshReceiptBlocks()
		}
		print("error: \(error.localizedDescription)")
	}
}

// MARK: - SKProductsRequestDelegate

extension StoreKitService: SKProductsRequestDelegate {
	
	public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
		products = response.products
		refreshSubscriptionsStatus(success: {
			print("success!")
		}) { (error) in
			print(error?.localizedDescription)
		}
//		purchase(
//			product: products.last!,
//			success: {
//				print("success!")
//		},
//			failure: { error in
//				print(error?.localizedDescription)
//		}
//		)
//		DispatchQueue.main.async {
//			NotificationCenter.default.post(name: .storeKitProductsDidLoad, object: nil)
//		}
	}
}

// MARK: - SKPaymentTransactionObserver

extension StoreKitService: SKPaymentTransactionObserver {
	
	public func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
		for transaction in transactions {
			switch (transaction.transactionState) {
			case .purchased, .restored:
				SKPaymentQueue.default().finishTransaction(transaction)
				notifyIsPurchased(transaction: transaction)
			case .failed:
				SKPaymentQueue.default().finishTransaction(transaction)
				print("purchase error : \(transaction.error?.localizedDescription ?? "")")
				self.failureBlock?(transaction.error)
				cleanUp()
			case .deferred, .purchasing:
				break
			default:
				break
			}
		}
	}
	
	private func notifyIsPurchased(transaction: SKPaymentTransaction) {
		refreshSubscriptionsStatus(
			success: {
				self.successBlock?()
				self.cleanUp() },
			failure: { (error) in
				self.failureBlock?(error)
				self.cleanUp() }
		)
	}
	
	func cleanUp(){
		self.successBlock = nil
		self.failureBlock = nil
	}
}
