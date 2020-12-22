//
//  SKProduct+LocalizedPrice.swift
//  Filmikus
//
//  Created by dmitriy korolchenko on 22.12.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import StoreKit

extension SKProduct {
    var localizedPrice: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = priceLocale
        formatter.maximumFractionDigits = 0
        return formatter.string(from: price) ?? "Бесплатно"
    }
}
