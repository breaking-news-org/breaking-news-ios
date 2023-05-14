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

// MARK: - Service

final class NewsServiceTests: XCTestCase {
	
	// MARK: Properties
	
	private var newsService: NewsServiceProtocol!
	
	private var mockAPIService: MockAPIService!
	
	// MARK: Setup
	
	override func setUpWithError() throws {
		try super.setUpWithError()
		
		mockAPIService = MockAPIService()
		newsService = withDependencies { dependency in
			dependency.apiService = mockAPIService
			dependency.encryptedStorage = MockEncryptedStorage()
		} operation: {
			NewsService()
		}
	}
	
	override func tearDownWithError() throws {
		newsService = nil
		mockAPIService = nil
		
		try super.tearDownWithError()
	}
	
	// MARK: Tests
	
	func testNews() async throws {
		// Test a successful news request
		mockAPIService.shouldFailNews = false
		let newsArticles = try await newsService.news()
		XCTAssertFalse(newsArticles.isEmpty)
	}
	
	func testNewsFailed() async throws {
		// Test a failing news request
		mockAPIService.shouldFailNews = true
		
		var didFailWithError: Bool = false
		do {
			_ = try await newsService.news()
		} catch {
			didFailWithError = true
		}
		XCTAssertTrue(didFailWithError)
	}
	
	func testCreateArticle() async throws {
		let title = "Test title"
		let text = "Test text"
		let imagesData = [Data()]
		
		// Test a successful create article request
		mockAPIService.shouldFailCreateArticle = false
		try await newsService.createArticle(
			title: title,
			text: text,
			imagesData: imagesData
		)
		XCTAssertTrue(true)
	}
	
	func testCreateArticleFailed() async throws {
		let title = "Test title"
		let text = "Test text"
		let imagesData = [Data()]
		
		// Test a failing create article request
		mockAPIService.shouldFailCreateArticle = true
		
		var didFailWithError: Bool = false
		do {
			try await newsService.createArticle(
				title: title,
				text: text,
				imagesData: imagesData
			)
		} catch {
			didFailWithError = true
		}
		XCTAssertTrue(didFailWithError)
	}
	
}
