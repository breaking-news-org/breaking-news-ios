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

// MARK: - View-model

final class NewsScreenViewModel: ObservableObject {

	// MARK: Exposed properties

	@MainActor @Published var news: [NewsArticle] = []

	@MainActor @Published var isAuthorized: Bool = false

	@MainActor @Published var nickname: String?

	// MARK: Private properties

	@Dependency(\.userService) private var userService: UserServiceProtocol

	@Dependency(\.newsService) private var newsService: NewsServiceProtocol

	// MARK: Init

	init() {
		Task {
			await MainActor.run {
				isAuthorized = userService.isAuthorized
				nickname = userService.nickname
			}
		}

		NotificationCenter.default.addObserver(
			forName: .refreshNews,
			object: nil,
			queue: .main,
			using: { [weak self] _ in self?.updateNews() }
		)

		NotificationCenter.default.addObserver(
			forName: .didChangeAuthorizationStatus,
			object: nil,
			queue: .main,
			using: authStatusChangeHandler(_:)
		)
	}

	deinit {
		NotificationCenter.default.removeObserver(self)
	}

	// MARK: Exposed properties

	func updateNews() {
		Task {
			do {
				let fetchedNews = try await newsService.news()

				await MainActor.run {
					news = fetchedNews
				}
			} catch let error {
				log.error(error)
			}
		}
	}

	func logout() {
		Task {
			do {
				try await userService.logOut()
			} catch let error {
				log.error(error)
			}
		}
	}

	// MARK: Private methods

	private func authStatusChangeHandler(_ notification: Notification) {
		Task {
			await MainActor.run {
				isAuthorized = userService.isAuthorized
				nickname = userService.nickname
			}
		}
	}

}
