//
//  AnalyticsService.swift
//  Filmikus
//
//  Created by dmitriy korolchenko on 12.04.2021.
//  Copyright © 2021 Андрей Козлов. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import StoreKit

class AnalyticsService {
    static let shared = AnalyticsService()
    private init() {}
    
    func setUserId(_ userId: String?) {
        Analytics.setUserID(userId)
        AppEvents.userID = userId
    }
    
    func trackPurchase(_ product: SKProduct) {
        trackPurchase(value: Double(truncating: product.price),
                      currency: product.priceLocale.currencyCode ?? "RUB")
    }
    
    func trackPurchase(value: Double, currency: String) {
        AppEvents.logPurchase(value, currency: currency)
    }
    
    func track(event: String, properties: [String : Any]) {
        Analytics.logEvent(event, parameters: properties)
        
        AppEvents.logEvent(AppEvents.Name(rawValue: event), parameters: properties)
    }
}
