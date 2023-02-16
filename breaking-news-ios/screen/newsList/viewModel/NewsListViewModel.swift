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

// MARK: - View model

final class NewsListViewModel: BaseViewModel, NewsListViewModelProtocol {

	// MARK: Exposed properties

	var news: AnyPublisher<[NewsDisplayModel], Never> {
		return $newsModels.eraseToAnyPublisher()
	}

	// MARK: Private properties

	private let router: UnownedRouter<AppRoute>

	private let newsService: NewsServiceProtocol

	@Published private var newsModels: [NewsDisplayModel] = [
		.randomMock(parameters: .all),
		.randomMock(parameters: [.images, .text]),
		.randomMock(parameters: .all),
		.randomMock(parameters: [.text, .category]),
		.randomMock(parameters: .all),
		.randomMock(parameters: [.text]),
		.randomMock(parameters: [.images, .text]),
		.randomMock(parameters: .all),
		.randomMock(parameters: [.text, .category]),
		.randomMock(parameters: .all),
		.randomMock(parameters: [.text]),
		.randomMock(parameters: [.images, .text]),
		.randomMock(parameters: .all),
		.randomMock(parameters: [.text, .category]),
		.randomMock(parameters: .all),
		.randomMock(parameters: [.text])
	].sorted(by: \.creationDate, using: >)

	// MARK: Init

	init(
		router: UnownedRouter<AppRoute>,
		newsService: NewsServiceProtocol,
		networkService: NetworkServiceProtocol
	) {
		self.router = router
		self.newsService = newsService
		super.init(networkService: networkService)
	}

	// MARK: Exposed methods

}
