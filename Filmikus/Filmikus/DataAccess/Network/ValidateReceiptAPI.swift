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
        "325bac5a10fd4dcd9274233dcf980c17"
    }
    
    var baseURL: URL {
        return URL(string: "https://sandbox.itunes.apple.com")!
//        return URL(string: "https://buy.itunes.apple.com/verifyReceipt")!
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
            json["exclude-old-transactions"] = false
            return .requestParameters(parameters: json, encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "Application/json"]
    }
}
