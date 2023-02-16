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
import Combine
import SpicyWrap

// MARK: - Service

final class UserService: UserServiceProtocol {

	// MARK: Exposed properties

	private(set) var accessToken: String?

	var isLoggedIn: Bool {
		return accessToken.isNotNil
	}

	var avatarUrl: URL? {
		return google.currentUser?.avatarUrl
	}

	// MARK: Private properties

	private var disposeBag: Set<AnyCancellable> = []

	private let google: GoogleAuthenticationServiceProtocol

	private let api: APIServiceProtocol

	// MARK: Init

	init(
		api: APIServiceProtocol,
		google: GoogleAuthenticationServiceProtocol
	) {
		self.google = google
		self.api = api
	}

	// MARK: Exposed methods

	func logIn() async throws {

	}

	func logOut() async throws {

	}

}
