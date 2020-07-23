//
//  SignUpFailureModel.swift
//  Filmikus
//
//  Created by Андрей Козлов on 23.07.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

struct SignUpFailureModel: Decodable {
	let message: String
	let code: String
	
	enum CodingKeys: String, CodingKey {
		case message = "err_desc"
		case code = "err_code"
	}
}
