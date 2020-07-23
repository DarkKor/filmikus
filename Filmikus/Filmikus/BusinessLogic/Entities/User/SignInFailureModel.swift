//
//  SignInFailureModel.swift
//  Filmikus
//
//  Created by Андрей Козлов on 23.07.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

struct SignInFailureModel: Codable {
	let errorDescription: String
	let errorCode: String
	
	enum CodingKeys: String, CodingKey {
		case errorDescription = "err_desc"
		case errorCode = "err_code"
	}
}
