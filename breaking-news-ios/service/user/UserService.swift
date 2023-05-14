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

final class UserService: UserServiceProtocol {

	// MARK: Exposed properties

	var isAuthorized: Bool {
		return encryptedStorage.accessToken != nil
	}

	var nickname: String? {
		return encryptedStorage.nickname
	}

	// MARK: Private properties

	@Dependency(\.apiService) private var apiService: APIServiceProtocol

	@Dependency(\.encryptedStorage) private var encryptedStorage: EncryptedStorageProtocol

	// MARK: Init

	init() {

	}

	deinit {
		NotificationCenter.default.removeObserver(self)
	}

	// MARK: Exposed methods

	func logIn(username: String, password: String) async throws {
		do {
			let request = LoginRequest(
				username: username,
				password: password
			)
			let response = try await apiService.login(
				request: request
			)

			encryptedStorage.nickname = nickname

			handleAfterAuthorization(
				accessToken: response.accessToken,
				refreshToken: response.refreshToken
			)
		} catch let error {
			throw error
		}
	}

	func register(nickname: String, username: String, password: String) async throws {
		do {
			let request = RegisterRequest(
				nickname: nickname,
				username: username,
				password: password
			)
			let response = try await apiService.register(
				request: request
			)

			encryptedStorage.nickname = nickname

			handleAfterAuthorization(
				accessToken: response.accessToken,
				refreshToken: response.refreshToken
			)
		} catch let error {
			throw error
		}
	}

	func logOut() async throws {
		encryptedStorage.refreshToken = nil
		encryptedStorage.accessToken = nil

		NotificationCenter.default.post(
			name: .didChangeAuthorizationStatus,
			object: nil
		)
	}

	func refreshUserSession() async throws {
		do {
			let response = try await apiService.rotateRefreshToken()
			handleAfterAuthorization(
				accessToken: response.accessToken,
				refreshToken: response.refreshToken
			)
		} catch {
			try await logOut()
		}
	}

	// MARK: Private properties

	private func handleAfterAuthorization(
		accessToken: String,
		refreshToken: String
	) {
		encryptedStorage.accessToken = accessToken
		encryptedStorage.refreshToken = refreshToken
		encryptedStorage.nickname = nickname

		NotificationCenter.default.post(
			name: .didChangeAuthorizationStatus,
			object: nil
		)
	}

}
