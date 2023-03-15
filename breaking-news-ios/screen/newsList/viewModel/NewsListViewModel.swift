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
import XCoordinator
import EverythingAtOnce

// MARK: - View model

final class NewsListViewModel: BaseViewModel, NewsListViewModelProtocol {

	// MARK: Exposed properties

	var state: AnyPublisher<NewsListScreenState, Never> {
		return $screenState.removeDuplicates().eraseToAnyPublisher()
	}

	var news: AnyPublisher<[NewsDisplayModel], Never> {
		return $newsModels
			.map({ $0.map(NewsDisplayModel.init(from:)) })
			.eraseToAnyPublisher()
	}

	// MARK: Private properties

	private let router: UnownedRouter<AppRoute>

	private let newsService: NewsServiceProtocol

	private var searchTask: Task<Void, Error>? {
		willSet {
			searchTask?.cancel()
		}
	}

	private var searchString: String = .emptyString

	@Published private var screenState: NewsListScreenState = .normal

	@Published private var newsModels: [News] = []

	// MARK: Init

	init(
		router: UnownedRouter<AppRoute>,
		newsService: NewsServiceProtocol,
		networkService: NetworkServiceProtocol
	) {
		self.router = router
		self.newsService = newsService
		super.init(networkService: networkService)

		self.search(string: .emptyString)
	}

	// MARK: Exposed methods

	func select(displayModel: NewsDisplayModel) {
		guard
			let news = newsModels.first(where: \.id == displayModel.id)
		else {
			return
		}
		router.trigger(.newsDetails(news: news))
	}

	func search(string: String) {
		searchString = string
		searchTask = Task {
			let filteredNews: [News] = try await newsService.newsList(
				filteredBy: [.titleContains(string)],
				sortedBy: .creationDate
			)

			try Task.checkCancellation()

			newsModels = filteredNews
		}
	}

	func openProfile() {
		Task {
			try await Service.google.signInOnCurrentViewController()
		}
	}

	func createNews() {
		screenState = .loading
		Task {
			try await Task.sleep(nanoseconds: 3 * NSEC_PER_SEC)
			screenState = .normal
		}
	}

}
