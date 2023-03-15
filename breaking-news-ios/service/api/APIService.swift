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
import EverythingAtOnce

// MARK: - Service

final class APIService: APIServiceProtocol {

	// MARK: Private properties

	private let provider: MoyaProvider<APIEndpoint>

	// MARK: Init

	init() {
		let configuration = NetworkLoggerPlugin.Configuration(
			output: { _, items in
				items.forEach { item in
					log.verbose(item)
				}
			}, logOptions: [
				.requestMethod, .requestBody,
				.successResponseBody, .errorResponseBody
			]
		)
		let loggerPlugin = NetworkLoggerPlugin(configuration: configuration)

		self.provider = MoyaProvider<APIEndpoint>(plugins: [loggerPlugin])
	}

	// MARK: Exposed methods

	func updateToken(_ token: String?) {
		APIEndpoint.accessToken = token
		log.info("Access token has been set to \(token ?? "nil") in the API service.")
	}

	func newsList(
		filteredBy filters: Set<NewsFilter>,
		sortedBy sort: NewsSort?
	) async throws -> [News] {
		let endpoint: APIEndpoint = .newsList(
			offsetLimit: nil,
			sort: sort,
			filters: filters
		)
		return try await request(endpoint, decode: [News].self)
	}

	// MARK: Private methods

	@discardableResult private static func process<ResponseBody: Decodable>(
		result: Result<Response, MoyaError>,
		decodeBody: ResponseBody.Type,
		allowCodes allowedCodes: Set<Int>
	) throws -> ResponseBody {
		switch result {
		case let .success(response):
			if allowedCodes.contains(response.statusCode) {
				return try JSONDecoder().decode(decodeBody.self, from: response.data)
			} else {
				throw APIError(code: response.statusCode)
			}
		case let .failure(error):
			throw error
		}
	}

	@discardableResult private func request<ResponseBody: Decodable>(
		_ endpoint: APIEndpoint,
		decode decodeBody: ResponseBody.Type
	) async throws -> ResponseBody {
		return try await withCheckedThrowingContinuation { continuation in
			provider.request(endpoint) { response in
				do {
					let responseBody = try APIService.process(
						result: response,
						decodeBody: decodeBody.self,
						allowCodes: [200]
					)
					continuation.resume(returning: responseBody)
				} catch let error {
					continuation.resume(throwing: error)
				}
			}
		}
	}

}
