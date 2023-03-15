//
//
//  MIT License
//
//  Copyright (c) 2023-Present
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
import EverythingAtOnce

// MARK: - Service

#if DEBUG
final class MockAPIService: APIServiceProtocol {

	// MARK: Private properties

	private var token: String?

	private let allNews: [News] = [
		.randomMock(parameters: .all),
		.randomMock(parameters: [.images, .text]),
		.randomMock(parameters: .all),
		.randomMock(parameters: .all),
		.randomMock(parameters: [.images, .text]),
		.randomMock(parameters: .all),
		.randomMock(parameters: .all),
		.randomMock(parameters: [.text]),
		.randomMock(parameters: [.images, .text]),
		.randomMock(parameters: .all),
		.randomMock(parameters: [.images, .category]),
		.randomMock(parameters: .all),
		.randomMock(parameters: [.text]),
		.randomMock(parameters: [.images, .text]),
		.randomMock(parameters: .all),
		.randomMock(parameters: .all),
		.randomMock(parameters: [.text])
	]

	// MARK: Exposed methods

	func updateToken(_ token: String?) {
		self.token = token
	}

	func newsList(
		filteredBy filters: Set<NewsFilter>,
		sortedBy sort: NewsSort?
	) async throws -> [News] {
		var result: [News] = allNews
		result = filterNews(news: result, using: filters)
		result = sortNews(news: result, using: sort)
		try await delay(for: 0.2)
		return result
	}

	// MARK: - Private methods

	private func delay(for interval: TimeInterval) async throws {
		try await Task.sleep(
			nanoseconds: UInt64(interval * TimeInterval(NSEC_PER_SEC))
		)
	}

	private func filterNews(news: [News], using filters: Set<NewsFilter>) -> [News] {
		var result: [News] = news
		for filter in filters {
			switch filter {
			case .authorNameContains(let string):
				guard string.isNotEmpty else { continue }
				result = result.filter({ news in
					return news.creator.lowercased().contains(string.lowercased())
				})
			case .categoryContains(let string):
				guard string.isNotEmpty else { continue }
				result = result.filter({ news in
					if let categoryText = news.category?.lowercased() {
						return categoryText.contains(string.lowercased())
					} else {
						return true
					}
				})
			case .createdAt(let date):
				result = result.filter({ news in
					news.creationDate == date
				})
			case .createdUntil(let date):
				result = result.filter({ news in
					news.creationDate < date
				})
			case .createdSince(let date):
				result = result.filter({ news in
					news.creationDate >= date
				})
			case .titleContains(let string):
				guard string.isNotEmpty else { continue }
				result = result.filter({ news in
					return news.title.lowercased().contains(string.lowercased())
				})
			case .textContains(let string):
				guard string.isNotEmpty else { continue }
				result = result.filter({ news in
					if let contentText = news.text?.lowercased() {
						return contentText.contains(string.lowercased())
					} else {
						return true
					}
				})
			}
		}
		return result
	}

	private func sortNews(news: [News], using sort: NewsSort?) -> [News] {
		if let sort {
			switch sort {
			case .categoryName:
				return news.sorted(by: { lhs, rhs in
					guard let lhsCategory = lhs.category else { return false }
					guard let rhsCategory = rhs.category else { return false }
					return lhsCategory > rhsCategory
				})
			case .authorName:
				return news.sorted(by: \.creator, using: >)
			case .creationDate:
				return news.sorted(by: \.creationDate, using: >)
			case .imageCount:
				return news.sorted(by: \.imageUrls.count, using: >)
			}
		} else {
			return news
		}
	}

}
#endif
