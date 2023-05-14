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
import Moya
import Alamofire
import Dependencies

// MARK: - Service

final class APIService: APIServiceProtocol {

	// MARK: Private properties

	@Dependency(\.encryptedStorage) private var encryptedStorage: EncryptedStorageProtocol

	private var provider: MoyaProvider<Endpoint>!

	// MARK: Init

	init() {
		let networkLoggerCongifuration = NetworkLoggerPlugin.Configuration(
			output: { _, items in
				items.forEach { item in
					log.verbose(item)
				}
			}, logOptions: [
				.requestMethod, .requestBody,
				.successResponseBody, .errorResponseBody
			]
		)
		let networkLoggerPlugin = NetworkLoggerPlugin(
			configuration: networkLoggerCongifuration
		)

		let accessTokenPlugin = AccessTokenPlugin(tokenClosure: { [weak self] _ in
			if let accessToken = self?.encryptedStorage.accessToken {
				return accessToken
			} else {
				return ""
			}
		})

		self.provider = MoyaProvider(plugins: [
			accessTokenPlugin,
			networkLoggerPlugin
		])
	}

	// MARK: Exposed methods

	func createArticle(request: CreateArticleRequest) async throws {
		_ = try await requestAndRotateTokenIfNeeded(
			.createArticle(requestBody: request),
			decoding: Empty.self
		)
	}

	func news(queryParameters: Set<NewsRequestQueryParamter>) async throws -> [NewsArticleResponse] {
		return try await requestAndRotateTokenIfNeeded(
			.news(queryParameters: queryParameters),
			decoding: [NewsArticleResponse].self
		)
	}

	func login(request: LoginRequest) async throws -> LoginResponse {
		return try await provider.request(
			.login(requestBody: request),
			decoding: LoginResponse.self
		)
	}

	func register(request: RegisterRequest) async throws -> RegisterResponse {
		return try await provider.request(
			.register(requestBody: request),
			decoding: RegisterResponse.self
		)
	}

	func rotateRefreshToken() async throws -> RotateRefreshTokenResponse {
		let response = try await provider.request(
			.rotateRefreshToken,
			decoding: RotateRefreshTokenResponse.self
		)
		encryptedStorage.accessToken = response.accessToken
		encryptedStorage.refreshToken = response.refreshToken
		return response
	}

	// MARK: Private methods

	/// Async moya request to decode a json body.
	fileprivate func requestAndRotateTokenIfNeeded<ResponseBody: Decodable>(
		_ endpoint: Endpoint,
		decoding responseBodyType: ResponseBody.Type
	) async throws -> ResponseBody {
		return try await provider.request(endpoint, decoding: ResponseBody.self)
//		do {
//			return try await provider.request(endpoint, decoding: ResponseBody.self)
//		} catch {
//			_ = try await rotateRefreshToken()
//			return try await provider.request(endpoint, decoding: ResponseBody.self)
//		}
	}

}

// MARK: - Endpoint

extension APIService {

	fileprivate enum Endpoint: TargetType, AccessTokenAuthorizable {

		// MARK: Cases

		case rotateRefreshToken

		case news(queryParameters: Set<NewsRequestQueryParamter>)

		case createArticle(requestBody: CreateArticleRequest)

		case login(requestBody: LoginRequest)

		case register(requestBody: RegisterRequest)

		// MARK: Exposed properties

		fileprivate(set) static var baseUrl: URL = URL(string: "http://breaking-news.fun:30006")!

		var baseURL: URL {
			return Endpoint.baseUrl
		}

		var headers: [String: String]? {
			return [
				"Accept": "application/json;charset=utf-8",
				"Content-Type": "application/json;charset=utf-8"
			]
		}

		var authorizationType: AuthorizationType? {
			switch self {
			case .login, .register:
				return .none
			case .news, .rotateRefreshToken, .createArticle:
				return .bearer
			}
		}

		var path: String {
			switch self {
			case .news:
				return "/api1/news/get"
			case .login:
				return "/api1/user/login"
			case .register:
				return "/api1/user/register"
			case .createArticle:
				return "/api1/news/create"
			case .rotateRefreshToken:
				return "/api1/user/rotate-refresh-token"
			}
		}

		var method: Moya.Method {
			switch self {
			case .news:
				return .get
			case .login, .register, .rotateRefreshToken, .createArticle:
				return .post
			}
		}

		var task: Moya.Task {
			switch self {
			case .rotateRefreshToken:
				return .requestPlain
			case let .login(requestBody):
				return .requestJSONEncodable(requestBody)
			case let .register(requestBody):
				return .requestJSONEncodable(requestBody)
			case let .createArticle(requestBody):
				return .requestJSONEncodable(requestBody)
			case let .news(queryParameters):
				let parameterDictionary = Dictionary(
					queryParameters.map(\.paramterPair),
					uniquingKeysWith: { _, new in new }
				)
				return .requestParameters(
					parameters: parameterDictionary,
					encoding: URLEncoding(destination: .queryString)
				)
			}
		}

	}

}

// MARK: - Moya+async

extension MoyaProvider {

	/// Async version of default moya request. Uses default queue for callbacks.
	private func request(_ target: Target, progress: ProgressBlock? = nil) async throws -> Response {
		return try await withUnsafeThrowingContinuation { continuation in
			request(target, progress: progress, completion: { result in
				do {
					try _Concurrency.Task.checkCancellation()
					continuation.resume(with: result)
				} catch let error {
					continuation.resume(throwing: error)
				}
			})
		}
	}

	/// Async moya request to decode a json body.
	fileprivate func request<ResponseBody: Decodable>(
		_ target: Target,
		decoding responseBodyType: ResponseBody.Type,
		progress: ProgressBlock? = nil
	) async throws -> ResponseBody {
		let response = try await request(target, progress: progress)

		if let decodedBody = try? JSONDecoder().decode(
			ResponseBody.self,
			from: response.data
		) {
			return decodedBody
		} else if let decodedBody = try? JSONDecoder().decode(
			APIResponse<APIError, ResponseBody>.self,
			from: response.data
		) {
			switch decodedBody {
			case let .right(body):
				return body
			case let .left(error):
				throw error
			}
		} else {
			throw APIError.unknown
		}
	}

}
