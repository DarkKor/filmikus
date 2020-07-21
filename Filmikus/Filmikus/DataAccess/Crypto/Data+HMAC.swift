//
//  Data+HMAC.swift
//  Filmikus
//
//  Created by Андрей Козлов on 20.07.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import Foundation
import CommonCrypto

extension Data {
	enum CryptoAlgorithm {
		case MD5, SHA1, SHA224, SHA256, SHA384, SHA512
		
		var HMACAlgorithm: CCHmacAlgorithm {
			var result: Int = 0
			switch self {
			case .MD5:      result = kCCHmacAlgMD5
			case .SHA1:     result = kCCHmacAlgSHA1
			case .SHA224:   result = kCCHmacAlgSHA224
			case .SHA256:   result = kCCHmacAlgSHA256
			case .SHA384:   result = kCCHmacAlgSHA384
			case .SHA512:   result = kCCHmacAlgSHA512
			}
			return CCHmacAlgorithm(result)
		}
		
		var digestLength: Int {
			var result: Int32 = 0
			switch self {
			case .MD5:      result = CC_MD5_DIGEST_LENGTH
			case .SHA1:     result = CC_SHA1_DIGEST_LENGTH
			case .SHA224:   result = CC_SHA224_DIGEST_LENGTH
			case .SHA256:   result = CC_SHA256_DIGEST_LENGTH
			case .SHA384:   result = CC_SHA384_DIGEST_LENGTH
			case .SHA512:   result = CC_SHA512_DIGEST_LENGTH
			}
			return Int(result)
		}
	}
	
	var hexString: String {
		return map { String(format: "%02hhx", $0) }.joined()
	}
	
	func HMAC(withKey key: Data, using algorithm: CryptoAlgorithm) -> Data {
		var result = Data(count: Int(algorithm.digestLength))
		result.withUnsafeMutableBytes({ resultRawBufferPointer in
			self.withUnsafeBytes({ dataRawBufferPointer in
				key.withUnsafeBytes({ keyRawBufferPointer -> Void in
					CCHmac(
						algorithm.HMACAlgorithm,
						keyRawBufferPointer.baseAddress,
						key.count,
						dataRawBufferPointer.baseAddress,
						self.count,
						resultRawBufferPointer.baseAddress
					)
				})
			})
		})
		return result
	}
}
