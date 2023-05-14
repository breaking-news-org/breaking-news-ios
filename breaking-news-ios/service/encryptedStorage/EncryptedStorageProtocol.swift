//
//
//  MIT License
//
//  Copyright (c) 2023-Present BreakingNews
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//  

import Foundation

// MARK: - Protocol

protocol EncryptedStorageProtocol: AnyObject {

	// Methods

	func get(key: String) throws -> String?

	func set(_ value: String, key: String) throws

	func remove(key: String) throws

}

// MARK: - Common values

extension EncryptedStorageProtocol {

	var accessToken: String? {
		get {
			return try? get(key: EncryptedStorageKey.accessToken)
		}
		set {
			if let newValue {
				try? set(newValue, key: EncryptedStorageKey.accessToken)
			} else {
				try? remove(key: EncryptedStorageKey.accessToken)
			}
		}
	}

	var refreshToken: String? {
		get {
			return try? get(key: EncryptedStorageKey.refreshToken)
		}
		set {
			if let newValue {
				try? set(newValue, key: EncryptedStorageKey.refreshToken)
			} else {
				try? remove(key: EncryptedStorageKey.refreshToken)
			}
		}
	}

	var username: String? {
		get {
			return try? get(key: EncryptedStorageKey.username)
		}
		set {
			if let newValue {
				try? set(newValue, key: EncryptedStorageKey.username)
			} else {
				try? remove(key: EncryptedStorageKey.username)
			}
		}
	}

	var nickname: String? {
		get {
			return try? get(key: EncryptedStorageKey.nickname)
		}
		set {
			if let newValue {
				try? set(newValue, key: EncryptedStorageKey.nickname)
			} else {
				try? remove(key: EncryptedStorageKey.nickname)
			}
		}
	}

}
