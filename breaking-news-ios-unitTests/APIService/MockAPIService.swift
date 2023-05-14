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
@testable import breaking_news_ios

// MARK: - Service

class MockAPIService: APIServiceProtocol {
	
	// MARK: Error type
	
	enum MockError: Error {
		case error
	}
	
	// MARK: Exposed properties
	
	var shouldFailNews = false
	
	var shouldFailCreateArticle = false
	
	var shouldFailLogin = false
	
	var shouldFailRegister = false
	
	var shouldFailRotateRefreshToken = false
	
	// MARK: Methods
	
	func news(queryParameters: Set<NewsRequestQueryParamter>) async throws -> [NewsArticleResponse] {
		if shouldFailNews {
			throw MockError.error
		}
		
		return [
			NewsArticleResponse(
				id: 1,
				text: "Article text",
				title: "Article title",
				authorName: "Author name",
				category: 1,
				isPublished: true,
				images: [],
				creationDate: Date()
			)
		]
	}
	
	func createArticle(request: CreateArticleRequest) async throws {
		if shouldFailCreateArticle {
			throw MockError.error
		}
	}
	
	func login(request: LoginRequest) async throws -> LoginResponse {
		if shouldFailLogin {
			throw MockError.error
		}
		
		return LoginResponse(
			accessToken: "access_token",
			refreshToken: "refresh_token"
		)
	}
	
	func register(request: RegisterRequest) async throws -> RegisterResponse {
		if shouldFailRegister {
			throw MockError.error
		}
		
		return RegisterResponse(
			accessToken: "access_token",
			refreshToken: "refresh_token"
		)
	}
	
	func rotateRefreshToken() async throws -> RotateRefreshTokenResponse {
		if shouldFailRotateRefreshToken {
			throw MockError.error
		}
		
		return RotateRefreshTokenResponse(
			accessToken: "new_access_token",
			refreshToken: "new_refresh_token"
		)
	}

}
