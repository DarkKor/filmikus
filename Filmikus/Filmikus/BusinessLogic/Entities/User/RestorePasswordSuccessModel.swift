//
//  RestorePasswordSuccessModel.swift
//  Filmikus
//
//  Created by Алесей Гущин on 19.08.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import Foundation

struct RestorePasswordSuccessModel: Decodable {
    let userId: Int
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
    }
}
