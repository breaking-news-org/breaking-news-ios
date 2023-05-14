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
import Dependencies

// MARK: - Service

final class NewsService: NewsServiceProtocol {

	// MARK: Private properties

	@Dependency(\.apiService) private var apiService: APIServiceProtocol

	// MARK: Exposed methods

	func createArticle(
		title: String,
		text: String,
		imagesData: [Data]
	) async throws {
		let request = CreateArticleRequest(
			title: title,
			content: text,
			images: imagesData.compactMap({ $0.base64EncodedString()}),
			category: 1,
			isPublished: true
		)
		try await apiService.createArticle(request: request)
	}

	func news() async throws -> [NewsArticle] {
		return try await apiService
			.news(queryParameters: [.page(pageNumber: 0)])
			.map(NewsArticle.init(from:))
			.sorted(by: \.creationDate, using: >)
	}

}
