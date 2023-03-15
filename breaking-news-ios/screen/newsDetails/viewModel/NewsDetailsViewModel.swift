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

final class NewsDetailsViewModel: BaseViewModel, NewsDetailsViewModelProtocol {

	// MARK: Exposed methods

	var screenTitle: AnyPublisher<String, Never> {
		return $_screenTitle
			.removeDuplicates()
			.eraseToAnyPublisher()
	}

	var newsDisplayModel: AnyPublisher<NewsDisplayModel, Never> {
		return $news
			.map(NewsDisplayModel.init(from:))
			.eraseToAnyPublisher()
	}

	// MARK: Private properties

	@Published private var _screenTitle: String

	@Published private var news: News

	private let router: UnownedRouter<AppRoute>

	// MARK: Init

	init(
		router: UnownedRouter<AppRoute>,
		networkService: NetworkServiceProtocol,
		news: News
	) {
		self._screenTitle = news.title
		self.news = news
		self.router = router
		super.init(networkService: networkService)
	}

	// MARK: Exposed methods

	func share() {
		#warning("Implementation required.")
	}

	func back() {
		router.trigger(.back)
	}

	// MARK: Private methods

}
