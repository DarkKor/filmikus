//
//  ValidateReceiptAPI.swift
//  Filmikus
//
//  Created by Алесей Гущин on 07.08.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import Moya

enum ValidateReceiptAPI {
    case validate(receipt: String)
}

extension ValidateReceiptAPI: TargetType {
    
    var sharedSecretKey: String {
        "226c5369f1904a3d95dc47003b7875d9"
    }
    
    var baseURL: URL {
        URL(string: "https://sandbox.itunes.apple.com")!
//        URL(string: "https://buy.itunes.apple.com")!
    }
    
    var path: String {
        "/verifyReceipt"
    }
    
    var method: Method {
        .post
    }
    
    var sampleData: Data {
        Data()
    }
    
    var task: Task {
        var json = [String: Any]()
        switch self {
        case let .validate(receipt):
            json["receipt-data"] = receipt
            json["password"] = sharedSecretKey
            json["exclude-old-transactions"] = true
            return .requestParameters(parameters: json, encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "Application/json"]
    }
}
