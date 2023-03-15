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

import UIKit
import EverythingAtOnce
import GoogleSignIn

// MARK: - Service

/// Service that manages the google authentication flows. Should be a shared instance.
final class GoogleAuthenticationService: GoogleAuthenticationServiceProtocol {

	// MARK: Exposed properties

	var currentUser: GoogleUser? {
		return GIDSignIn.sharedInstance.currentUser.flatMap(GoogleUser.init(from:))
	}

	// MARK: Init

	init(clientId: String) {
		GIDSignIn.sharedInstance.configuration = GIDConfiguration(clientID: clientId)
	}

	// MARK: Methods

	@MainActor func signInOnCurrentViewController() async throws -> GoogleUser {
		guard
			let viewController = UIApplication.shared.topViewController
		else {
			throw ServiceError.noViewController
		}
		return try await signIn(onViewController: viewController)
	}

	@MainActor @discardableResult func signIn(
		onViewController viewController: UIViewController
	) async throws -> GoogleUser {
		return try await withCheckedThrowingContinuation { continuation in
			GIDSignIn.sharedInstance.signIn(
				withPresenting: viewController
			) { result, error in
				if let user = result?.user {
					if let googleUser = GoogleUser.init(from: user) {
						continuation.resume(returning: googleUser)
					} else {
						continuation.resume(throwing: ServiceError.cannotDecodeUserModel)
					}
				} else if let error {
					continuation.resume(throwing: error)
				} else {
					continuation.resume(throwing: ServiceError.unknownGoogleResponse)
				}
			}
		}
	}

	func signOut() {
		GIDSignIn.sharedInstance.signOut()
	}

	func handle(_ url: URL) -> Bool {
		return GIDSignIn.sharedInstance.handle(url)
	}

	@discardableResult func restorePreviousSignInIfPresent() async throws -> GoogleUser {
		return try await withCheckedThrowingContinuation { continuation in
			if GIDSignIn.sharedInstance.hasPreviousSignIn() {
				GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
					if let user = user {
						if let googleUser = GoogleUser.init(from: user) {
							continuation.resume(returning: googleUser)
						} else {
							continuation.resume(throwing: ServiceError.cannotDecodeUserModel)
						}
					} else if let error = error {
						continuation.resume(throwing: error)
					} else {
						continuation.resume(throwing: ServiceError.unknownGoogleResponse)
					}
				}
			} else {
				continuation.resume(throwing: ServiceError.noPreviousSignInFound)
			}
		}
	}

}

// MARK: - Error

extension GoogleAuthenticationService {

	enum ServiceError: UInt8, Error {

		case noViewController

		case noCliendIdFound

		case noPreviousSignInFound

		case unknownGoogleResponse

		case cannotDecodeUserModel

	}

}
