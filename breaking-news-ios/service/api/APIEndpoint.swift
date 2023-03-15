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
import Moya

// MARK: - Endpoint

enum APIEndpoint {

	// MARK: Exposed properties

	static var accessToken: String? = nil

	static var baseUrl: URL = URL(string: "http://breaking-news.fun")!

	// MARK: Cases

	case newsList(
		offsetLimit: OffsetLimit? = nil,
		sort: NewsSort? = nil,
		filters: Set<NewsFilter> = []
	)

}

// MARK: - TargetType

extension APIEndpoint: TargetType {

	var baseURL: URL {
		return APIEndpoint.baseUrl
	}

	var path: String {
		switch self {
		case let .newsList(offsetLimit, sort, filters):
			let path = "/api/v1/news_list"
			var components = URLComponents()
			components.queryItems = [
				offsetLimit?.queryItems,
				sort?.queryItems,
				filters.queryItems
			].compactMap({ $0 }).flatMap({ $0 })

			if let query = components.query {
				return path + "?" + query
			} else {
				return path
			}
		}
	}

	var method: Moya.Method {
		switch self {
		case .newsList:
			return .get
		}
	}

	var task: Moya.Task {
		switch self {
		case .newsList:
			return .requestPlain
		}
	}

	var headers: [String: String]? {
		var headers: [String: String] = [
			"platform": "ios"
		]
		if let token = APIEndpoint.accessToken {
			headers["access_token"] = token
		}
		return headers
	}

}
