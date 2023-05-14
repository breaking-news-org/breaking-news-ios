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

import SwiftUI
import Dependencies

// MARK: - View-model

final class AuthScreenViewModel: ObservableObject {

	// MARK: Exposed properties

	let screenModes: [AuthScreenMode] = [.login, .register]

	@MainActor @Published var screenMode: AuthScreenMode = .login

	@MainActor @Published var isLoading: Bool = false

	@MainActor @Published var shouldShowUserNotFoundToast: Bool = false

	@MainActor @Published var nickname: String = ""

	@MainActor @Published var username: String = ""

	@MainActor @Published var password: String = ""

	@MainActor @Published var repeatedPassword: String = ""

	@MainActor var isUsernameValid: Bool {
		return 1 <= username.count
	}

	@MainActor var isNicknameValid: Bool {
		return 1 <= nickname.count
	}

	@MainActor var isPasswordValid: Bool {
		return 1 <= password.count
	}

	@MainActor var isRepeatedPasswordValid: Bool {
		return isPasswordValid && (password == repeatedPassword)
	}

	@MainActor var isLoginFormValid: Bool {
		return isUsernameValid && isPasswordValid
	}

	@MainActor var isRegisterFormValid: Bool {
		return isNicknameValid
			&& isUsernameValid
			&& isPasswordValid
			&& isRepeatedPasswordValid
	}

	// MARK: Private properties

	private let dismissAction: (() -> Void)?

	@Dependency(\.userService) private var userService: UserServiceProtocol

	// MARK: Init

	init(dismissAction: (() -> Void)? = nil) {
		self.dismissAction = dismissAction
	}

	// MARK: Exposed methods

	@MainActor func logIn() {
		guard
			!isLoading
		else {
			return
		}

		isLoading = true

		Task {
			do {
				try await userService.logIn(
					username: username,
					password: password
				)
				await MainActor.run {
					dismissAction?()
				}
			} catch let error {
				if let apiError = error as? APIError, apiError == APIError.userNotFound {
					await MainActor.run {
						shouldShowUserNotFoundToast = true

						withAnimation {
							screenMode = .register
						}
					}
				}

				log.error(error)
			}

			await MainActor.run {
				isLoading = false
			}
		}
	}

	@MainActor func register() {
		guard
			!isLoading
		else {
			return
		}

		isLoading = true

		Task {
			do {
				try await userService.register(
					nickname: nickname,
					username: username,
					password: password
				)
				await MainActor.run {
					dismissAction?()
				}
			} catch let error {
				log.error(error)
			}

			await MainActor.run {
				isLoading = false
			}
		}
	}

}
