//
//  AES256.swift
//  Filmikus
//
//  Created by Андрей Козлов on 20.07.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import Foundation
import CommonCrypto

struct AES256 {
	let key: Data
	let iv: Data
	
	init(key: Data, iv: Data) throws {
		guard key.count == kCCKeySizeAES256 else {
			throw Error.badKeyLength
		}
		guard iv.count == kCCBlockSizeAES128 else {
			throw Error.badInputVectorLength
		}
		self.key = key
		self.iv = iv
	}
	
	enum Error: Swift.Error {
		case keyGeneration(status: Int)
		case cryptoFailed(status: CCCryptorStatus)
		case badKeyLength
		case badInputVectorLength
	}
	
	func encrypt(_ digest: Data) throws -> Data {
		return try crypt(input: digest, operation: CCOperation(kCCEncrypt))
	}
	
	func decrypt(_ encrypted: Data) throws -> Data {
		return try crypt(input: encrypted, operation: CCOperation(kCCDecrypt))
	}
	
	private func crypt(input: Data, operation: CCOperation) throws -> Data {
		var outLength = Int(0)
		var outBytes = [UInt8](repeating: 0, count: input.count + kCCBlockSizeAES128)
		var status: CCCryptorStatus = CCCryptorStatus(kCCSuccess)
		input.withUnsafeBytes { (inputRawBufferPointer) -> Void in
			iv.withUnsafeBytes { (ivRawBufferPointer) -> Void in
				key.withUnsafeBytes { (keyRawBufferPointer) -> Void in
					status = CCCrypt(
						operation,
						CCAlgorithm(kCCAlgorithmAES128), // algorithm
						CCOptions(kCCOptionPKCS7Padding), // options
						keyRawBufferPointer.baseAddress, // key
						key.count, // keylength
						ivRawBufferPointer.baseAddress, // iv
						inputRawBufferPointer.baseAddress, // dataIn
						input.count, // dataInLength
						&outBytes, // dataOut
						outBytes.count, // dataOutAvailable
						&outLength // dataOutMoved
					)
				}
			}
		}
		guard status == kCCSuccess else {
			throw Error.cryptoFailed(status: status)
		}
		return Data(bytes: outBytes, count: outLength)
	}
	
	static func randomIv() -> Data {
		return randomData(length: kCCBlockSizeAES128)
	}
	
	static func randomSalt() -> Data {
		return randomData(length: 8)
	}
	
	static func randomData(length: Int) -> Data {
		var data = Data(count: length)
		let status = data.withUnsafeMutableBytes { statusRawBufferPointer -> Int32 in
			let statusPointer = statusRawBufferPointer.baseAddress!
			return SecRandomCopyBytes(kSecRandomDefault, length, statusPointer)
		}
		assert(status == Int32(0))
		return data
	}
}

