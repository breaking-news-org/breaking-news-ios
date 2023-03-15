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

// MARK: - Controller

final class NewsListViewController: BaseViewController {

	// MARK: Private properties

	private let viewModel: NewsListViewModelProtocol

	private var contentView: NewsListView! {
		return view as? NewsListView
	}

	// MARK: Init

	init(viewModel: NewsListViewModelProtocol) {
		self.viewModel = viewModel
		super.init()
	}

	// MARK: Lifecycle

	override func loadView() {
		view = NewsListView(frame: .zero)
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		subscribeOnViewModel()
		subscribeOnContentView()
	}

	// MARK: Private methods

	private func subscribeOnContentView() {
		disposeBag.collect {
			contentView.searchString
				.sink(receiveValue: viewModel.search(string:))

			contentView.didTapCreateNews
				.sink(receiveValue: viewModel.createNews)

			contentView.didTapProfile
				.sink(receiveValue: viewModel.openProfile)

			contentView.didSelectDisplayModel
				.sink(receiveValue: viewModel.select(displayModel:))
		}
	}

	private func subscribeOnViewModel() {
		disposeBag.collect {
			viewModel.state
				.receive(on: DispatchQueue.main)
				.sink(receiveValue: contentView.set(state:))

			viewModel.news
				.receive(on: DispatchQueue.main)
				.sink(receiveValue: contentView.set(newsDisplayModels:))
		}
	}

}
