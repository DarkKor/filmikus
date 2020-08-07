//
//  ReceiptModel.swift
//  Filmikus
//
//  Created by Алесей Гущин on 07.08.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import Foundation

struct ReceiptModel: Decodable {
    
    let expirationDate: Date?
    
    enum CodingKeys: String, CodingKey {
        case expirationDate = "expires_date"
    }
    
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
        
    
        let date = try container.decode(String.self, forKey: .expirationDate)
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss VV"
        expirationDate = formatter.date(from: date)
    }
}
