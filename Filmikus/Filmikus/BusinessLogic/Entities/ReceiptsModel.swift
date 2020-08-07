//
//  ReceiptsModel.swift
//  Filmikus
//
//  Created by Алесей Гущин on 07.08.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import Foundation

struct ReceiptsModel: Decodable {
    
    let receipts: [ReceiptModel]?
    
    enum CodingKeys: String, CodingKey {
        case latestReceipt = "latest_receipt_info"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        receipts = try container.decodeIfPresent([ReceiptModel].self, forKey: .latestReceipt)
    }
}
