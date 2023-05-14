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
import Dependencies
@testable import breaking_news_ios

// MARK: - Test class

final class UserServiceTests: XCTestCase {
	
	// MARK: Properties
	
	private var userService: UserServiceProtocol!
	
	private var mockAPIService: MockAPIService!
	
	// MARK: Setup
	
	override func setUpWithError() throws {
		try super.setUpWithError()
		
		mockAPIService = MockAPIService()
		userService = withDependencies { dependency in
			dependency.apiService = mockAPIService
			dependency.encryptedStorage = MockEncryptedStorage()
		} operation: {
			UserService()
		}
	}
	
	override func tearDownWithError() throws {
		mockAPIService = nil
		userService = nil
		
		try super.tearDownWithError()
	}
	
	// MARK: Tests
	
	func testRegister() async throws {
		let nickname = "Test"
		let username = "test@test.com"
		let password = "password"
		
		// Test a successful registration
		mockAPIService.shouldFailRegister = false
		try await userService.register(
			nickname: nickname,
			username: username,
			password: password
		)
		XCTAssertTrue(userService.isAuthorized)
		XCTAssertEqual(userService.nickname, nickname)
	}
	
	func testRegisterFailed() async throws {
		let nickname = "Test"
		let username = "test@test.com"
		let password = "password"
		
		// Test a failing registration
		mockAPIService.shouldFailRegister = true
		var didFailWithError: Bool = false
		do {
			try await userService.register(
				nickname: nickname,
				username: username,
				password: password
			)
		} catch {
			didFailWithError = true
		}
		XCTAssertTrue(didFailWithError)
		XCTAssertFalse(userService.isAuthorized)
		XCTAssertNil(userService.nickname)
	}
	
	func testLogin() async throws {
		let username = "test@test.com"
		let password = "password"
		
		// Test a successful login
		mockAPIService.shouldFailLogin = false
		try await userService.logIn(username: username, password: password)
		XCTAssertTrue(userService.isAuthorized)
	}
	
	func testLoginFailed() async throws {
		let username = "test@test.com"
		let password = "password"
		
		// Test a failing login
		mockAPIService.shouldFailLogin = true
		var didFailWithError: Bool = false
		do {
			try await userService.logIn(username: username, password: password)
		} catch {
			didFailWithError = true
		}
		XCTAssertTrue(didFailWithError)
		XCTAssertFalse(userService.isAuthorized)
	}
	
	func testLogout() async throws {
		// Test a successful logout
		try await userService.logOut()
		XCTAssertFalse(userService.isAuthorized)
		XCTAssertNil(userService.nickname)
	}
	
	func testRefreshUserSession() async throws {
		// Test a successful refresh user session
		mockAPIService.shouldFailRotateRefreshToken = false
		try await userService.refreshUserSession()
		XCTAssertTrue(userService.isAuthorized)
	}

	func testRefreshUserSessionFailed() async throws {
		// Test a failing refresh user session
		mockAPIService.shouldFailRotateRefreshToken = true
		var didFailWithError: Bool = false
		do {
			try await userService.refreshUserSession()
		} catch {
			didFailWithError = true
		}
		XCTAssertTrue(didFailWithError)
		XCTAssertFalse(userService.isAuthorized)
	}
	
}
