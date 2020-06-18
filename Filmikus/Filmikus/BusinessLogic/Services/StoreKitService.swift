//
//  StoreKitService.swift
//  Filmikus
//
//  Created by Андрей Козлов on 19.05.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import StoreKit

protocol StoreKitServiceType: class {
	func loadProducts(completion: ((Result<[SKProduct], Error>) -> Void)?)
	func purchase(product: SKProduct, completion: ((Result<Void, Error>) -> Void)?)
	func refreshSubscriptionsStatus(completion: ((Result<Void, Error>) -> Void)?)
}

class StoreKitService: NSObject, StoreKitServiceType {
	
	typealias SubscriptionBlock = (Result<Void, Error>) -> Void
	typealias ProductsBlock = (Result<[SKProduct], Error>) -> Void
	
	private var subscriptionBlock: SubscriptionBlock?
	private var refreshSubscriptionBlock: SubscriptionBlock?
	private var productsBlock: ProductsBlock?
		
	private(set) var products: [SKProduct] = []

	static let shared = StoreKitService()
	
	private override init() {
		super.init()
		SKPaymentQueue.default().add(self)
	}
	
	// MARK:- Main methods
	
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
		guard let receiptData = try? Data(contentsOf: receiptUrl).base64EncodedString() else { return }
		print(receiptData)
		// Then we must send receipt data to the server for validation
		//
	}

	/*
	Should not be called directly. Call refreshSubscriptionsStatus instead.
	*/
	private func refreshReceipt() {
		let request = SKReceiptRefreshRequest(receiptProperties: nil)
		request.delegate = self
		request.start()
	}
	
	func loadProducts(completion: ProductsBlock? = nil) {
		guard products.isEmpty else {
			completion?(.success(products))
			return
		}
		let productIds: Set<String> = [
			"com.filmikustestsubscription.testapp",
			"com.filmikustestsubscription.year.testapp"
		]
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
		DispatchQueue.main.async {
			self.refreshSubscriptionBlock?(.failure(error))
			self.refreshSubscriptionBlock = nil
		}
	}
}

// MARK: - SKProductsRequestDelegate

extension StoreKitService: SKProductsRequestDelegate {
	
	public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
		products = response.products
		DispatchQueue.main.async {
			self.productsBlock?(.success(response.products))
		}
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
					DispatchQueue.main.async {
						self.subscriptionBlock?(result)
						self.subscriptionBlock = nil
					}
				}
			case .failed:
				SKPaymentQueue.default().finishTransaction(transaction)
				DispatchQueue.main.async {
					self.subscriptionBlock?(.failure(transaction.error ?? NSError()))
					self.subscriptionBlock = nil
				}
			case .deferred, .purchasing:
				break
			default:
				break
			}
		}
	}
}
