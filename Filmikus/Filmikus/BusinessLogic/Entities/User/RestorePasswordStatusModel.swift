//
//  RestorePasswordStatusModel.swift
//  Filmikus
//
//  Created by Алесей Гущин on 19.08.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import Foundation

enum RestorePasswordStatusModel: Decodable {
    case success(RestorePasswordSuccessModel)
    case failure(RestorePasswordFailureModel)
    
    enum CodingKeys: String, CodingKey {
        case status = "restore_status"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let status = try container.decode(String.self, forKey: .status)
        switch status {
        case "success":
            let model = try RestorePasswordSuccessModel(from: decoder)
            self = .success(model)
        case "fail":
            let model = try RestorePasswordFailureModel(from: decoder)
            self = .failure(model)
        default:
            throw NSError()
        }
    }
}
