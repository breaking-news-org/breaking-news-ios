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

final class APIServiceTests: XCTestCase {
	
	// MARK: Properties
	
	private var apiService: APIServiceProtocol!
	
	private var mockAPIService: MockAPIService!
	
	// MARK: Setup
	
	override func setUpWithError() throws {
		try super.setUpWithError()
		
		apiService = APIService()
		mockAPIService = MockAPIService()
	}
	
	override func tearDownWithError() throws {
		apiService = nil
		mockAPIService = nil
		
		try super.tearDownWithError()
	}
	
	// MARK: Tests
	
	func testNews() async throws {
		let queryParameters: Set<NewsRequestQueryParamter> = [
			.createdAt(date: Date()),
			.page(pageNumber: 1)
		]
		
		// Test a successful news request
		mockAPIService.shouldFailNews = false
		apiService = mockAPIService
		let newsArticles = try await apiService.news(queryParameters: queryParameters)
		XCTAssertFalse(newsArticles.isEmpty)
	}
	
	func testNewsFailure() async throws {
		let queryParameters: Set<NewsRequestQueryParamter> = [
			.createdAt(date: Date()),
			.page(pageNumber: 1)
		]
		
		// Test a failing news request
		mockAPIService.shouldFailNews = true
		apiService = mockAPIService
		
		var didFailWithError: Bool = false
		do {
			_ = try await apiService.news(queryParameters: queryParameters)
		} catch {
			didFailWithError = true
		}
		XCTAssertTrue(didFailWithError)
	}
	
	func testCreateArticle() async throws {
		let request = CreateArticleRequest(
			title: "Test article",
			content: "Test content",
			images: [],
			category: 1,
			isPublished: true
		)
		
		// Test a successful create article request
		mockAPIService.shouldFailCreateArticle = false
		apiService = mockAPIService
		try await apiService.createArticle(request: request)
		XCTAssertTrue(true)
	}
	
	func testCreateArticleFailure() async throws {
		let request = CreateArticleRequest(
			title: "Test article",
			content: "Test content",
			images: [],
			category: 1,
			isPublished: true
		)
		
		// Test a failing create article request
		mockAPIService.shouldFailCreateArticle = true
		apiService = mockAPIService
		
		var didFailWithError: Bool = false
		do {
			_ = try await apiService.createArticle(request: request)
		} catch {
			didFailWithError = true
		}
		XCTAssertTrue(didFailWithError)
	}
	
	func testLogin() async throws {
		let request = LoginRequest(
			username: "test_username",
			password: "test_password"
		)
		
		// Test a successful login request
		mockAPIService.shouldFailLogin = false
		apiService = mockAPIService
		let loginResponse = try await apiService.login(request: request)
		XCTAssertEqual(loginResponse.accessToken, "access_token")
		XCTAssertEqual(loginResponse.refreshToken, "refresh_token")
	}
	
	func testLoginFailure() async throws {
		let request = LoginRequest(
			username: "test_username",
			password: "test_password"
		)
		
		// Test a failing login request
		mockAPIService.shouldFailLogin = true
		apiService = mockAPIService
		
		var didFailWithError: Bool = false
		do {
			_ = try await apiService.login(request: request)
		} catch {
			didFailWithError = true
		}
		XCTAssertTrue(didFailWithError)
	}
	
	func testRegister() async throws {
		let request = RegisterRequest(
			nickname: "test_nickname",
			username: "test_username",
			password: "test_password"
		)
		
		// Test a successful register request
		mockAPIService.shouldFailRegister = false
		apiService = mockAPIService
		let registerResponse = try await apiService.register(request: request)
		XCTAssertEqual(registerResponse.accessToken, "access_token")
		XCTAssertEqual(registerResponse.refreshToken, "refresh_token")
	}
	
	func testRegisterFailure() async throws {
		let request = RegisterRequest(
			nickname: "test_nickname",
			username: "test_username",
			password: "test_password"
		)
		
		// Test a failing register request
		mockAPIService.shouldFailRegister = true
		apiService = mockAPIService
		
		var didFailWithError: Bool = false
		do {
			_ = try await apiService.register(request: request)
		} catch {
			didFailWithError = true
		}
		XCTAssertTrue(didFailWithError)
	}
	
	func testRotateRefreshToken() async throws {
		// Test a successful rotate refresh token request
		mockAPIService.shouldFailRotateRefreshToken = false
		apiService = mockAPIService
		let rotateRefreshTokenResponse = try await apiService.rotateRefreshToken()
		XCTAssertNotNil(rotateRefreshTokenResponse.accessToken)
		XCTAssertNotNil(rotateRefreshTokenResponse.refreshToken)
	}
	
	func testRotateRefreshTokenFailure() async throws {
		// Test a failing rotate refresh token request
		mockAPIService.shouldFailRotateRefreshToken = true
		apiService = mockAPIService
		
		var didFailWithError: Bool = false
		do {
			_ = try await apiService.rotateRefreshToken()
		} catch {
			didFailWithError = true
		}
		XCTAssertTrue(didFailWithError)
	}
	
}
