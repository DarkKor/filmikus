//
//  RestorePasswordFailureModel.swift
//  Filmikus
//
//  Created by Алесей Гущин on 19.08.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import Foundation

struct RestorePasswordFailureModel: Decodable {
    let message: String
    let code: String
    
    enum CodingKeys: String, CodingKey {
        case message = "err_desc"
        case code = "err_code"
    }
}
