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

// MARK: - Model

enum NewsRequestQueryParamter: Hashable, Equatable {

	// MARK: Cases

	case createdAt(date: Date)

	case createdUntil(date: Date)

	case createdSince(date: Date)

	case author(name: String)

	case category(id: Int)

	case title(containsText: String)

	case text(containsText: String)

	case page(pageNumber: Int)

	// MARK: Query parameter

	var queryItem: URLQueryItem {
		let queryPair: (String, String) = paramterPair
		return URLQueryItem(name: queryPair.0, value: queryPair.1)
	}

	var paramterPair: (String, String) {
		switch self {
		case let .page(pageNumber: pageNumber):
			return ("block", "\(pageNumber)")
		case let .createdAt(date):
			return ("createdAt", Formatters.iso8601DateFormatter.string(from: date))
		case let .createdUntil(date):
			return ("createdAt", Formatters.iso8601DateFormatter.string(from: date))
		case let .createdSince(date):
			return ("createdAt", Formatters.iso8601DateFormatter.string(from: date))
		case let .author(name):
			return ("authorName", name)
		case let .category(id):
			return ("category", "\(id)")
		case let .title(text):
			return ("titleLike", text)
		case let .text(text):
			return ("textLike", text)
		}
	}

}
