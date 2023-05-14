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

import XCTest
@testable import breaking_news_ios

// MARK: - Test class

final class EncryptedStorageTests: XCTestCase {
	
	// MARK: Properties
	
	private var encryptedStorage: EncryptedStorageProtocol!
	
	// MARK: Setup
	
	override func setUpWithError() throws {
		try super.setUpWithError()
		
		encryptedStorage = MockEncryptedStorage()
	}
	
	override func tearDownWithError() throws {
		encryptedStorage = nil
		
		try super.tearDownWithError()
	}
	
	// MARK: Tests
	
	func testSetGet() throws {
		let key = "test-key"
		let value = "test-value"
		
		try encryptedStorage.set(value, key: key)
		let storedValue = try encryptedStorage.get(key: key)
		XCTAssertEqual(storedValue, value)
	}
	
	func testSetGetInvalidKey() throws {
		let key = ""
		let value = "test-value"
		
		XCTAssertThrowsError(try encryptedStorage.set(value, key: key))
		XCTAssertThrowsError(try encryptedStorage.get(key: key))
	}
	
	func testRemove() throws {
		let key = "test-key"
		let value = "test-value"
		
		try encryptedStorage.set(value, key: key)
		try encryptedStorage.remove(key: key)
		let storedValue = try encryptedStorage.get(key: key)
		XCTAssertNil(storedValue)
	}

}
