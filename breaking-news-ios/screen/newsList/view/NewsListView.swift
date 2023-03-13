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
import Combine
import Kingfisher
import EverythingAtOnce

// MARK: - View

final class NewsListView: BaseView {

	// MARK: Exposed properties

	var searchString: AnyPublisher<String, Never> {
		return $_searchString
			.removeDuplicates()
			.throttle(for: 0.5, scheduler: RunLoop.main, latest: true)
			.eraseToAnyPublisher()
	}

	var didTapProfile: AnyPublisher<Void, Never> {
		return profileButton.pressGesturePublisher
			.mapEmpty()
			.eraseToAnyPublisher()
	}

	var didTapCreateNews: AnyPublisher<Void, Never> {
		return createButton.pressGesturePublisher
			.mapEmpty()
			.eraseToAnyPublisher()
	}

	// MARK: Private properties

	@Published private var _searchString: String = ""

	@Published private var _models: [NewsDisplayModel] = []

	// MARK: Subviews

	private lazy var profileLabel: UILabel = UILabel(frame: .zero)
		.setText(Lorem.longSentence)
		.setFont(.h4Bold)
		.setTextColor(Asset.Colors.blackBean.color)
		.setNumberOfLines(1)

	private lazy var profileButton: ShadowedButton = ShadowedButton(frame: .zero)
		.setImage(Asset.Images.user.image, forState: .normal)
		.setTintColor(Asset.Colors.blackBean.color)
		.setBackgroundColor(Asset.Colors.babyPowder.color)

	private lazy var createButton: ShadowedButton = ShadowedButton(frame: .zero)
		.setImage(Asset.Images.edit.image, forState: .normal)
		.setTintColor(Asset.Colors.blackBean.color)
		.setBackgroundColor(Asset.Colors.babyPowder.color)

	private lazy var searchBar: UISearchBar = {
		let subview =  UISearchBar(frame: .zero)
		subview.barStyle = .default
		subview.searchBarStyle = .prominent
		subview.autocorrectionType = .no
		subview.keyboardType = .alphabet
		subview.searchTextField.font = .h4Regular
		subview.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
		subview.sizeToFit()
		return subview
	}()

	private lazy var tableView: UITableView = UITableView(frame: .zero)
		.setDataSource(self)
		.setDelegate(self)
		.setRegistered(cellClass: NewsListCell.self)
		.setSeparatorStyle(.none)

	// MARK: Init

	override init(frame: CGRect) {
		super.init(frame: frame)
		self.$_models
			.receive(on: DispatchQueue.main)
			.mapEmpty()
			.sink(receiveValue: tableView.reloadData)
			.store(in: &disposeBag)
	}

	// MARK: Override

	override func setupSubviewHierarchy() {
		super.setupSubviewHierarchy()
		addSubviews {
			VerticalStack {
				UIView {
					profileButton.withConstraints {
						pinLeading(toSuperview: .leading, offset: 30)
						pinCenterY(toSuperview: .centerY)
						pinWidth(to: 50)
						pinHeight(to: 50)
					}

					createButton.withConstraints {
						pinTrailing(toSuperview: .trailing, offset: -30)
						pinCenterY(toSuperview: .centerY)
						pinWidth(to: 38)
						pinHeight(to: 38)
					}

					profileLabel.withConstraints {
						pinCenterY(toSuperview: .centerY)
						pinLeading(to: .trailing, of: profileButton, offset: 16)
						pinTrailing(to: .leading, of: createButton, offset: -16)
					}
				}
				.withConstraints {
					pinHeight(to: 100)
					pinLeading(toSuperview: .leading)
					pinTrailing(toSuperview: .trailing)
				}

				searchBar.withConstraints {
					pinHeight(to: 60)
					pinWidth(toSuperview: .width)
				}

				tableView.withConstraints {
					pinLeading(toSuperview: .leading)
					pinTrailing(toSuperview: .trailing)
				}
			}
			.withConstraints { [self] in
				pinTop(to: .top, of: safeAreaLayoutGuide)
				pinBottom(toSuperview: .bottom)
				pinLeading(toSuperview: .leading)
				pinTrailing(toSuperview: .trailing)
			}
		}
	}

	// MARK: Exposed methods

	func set(newsDisplayModels: [NewsDisplayModel]) {
		_models = newsDisplayModels
	}

	// MARK: Private methods

}

// MARK: - UITableViewDataSource

extension NewsListView: UITableViewDataSource {

	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	func tableView(
		_ tableView: UITableView,
		numberOfRowsInSection section: Int
	) -> Int {
		return _models.count
	}

	func tableView(
		_ tableView: UITableView,
		cellForRowAt indexPath: IndexPath
	) -> UITableViewCell {
		let model: NewsDisplayModel = _models[indexPath.row]
		let cell: NewsListCell = tableView.dequeue(for: indexPath)
		cell.set(newsDisplayModel: model)
		return cell
	}

}

// MARK: - UITableViewDelegate

extension NewsListView: UITableViewDelegate {

	func tableView(
		_ tableView: UITableView,
		heightForRowAt indexPath: IndexPath
	) -> CGFloat {
		return UITableView.automaticDimension
	}

}

// MARK: - Preview

#if DEBUG
import SwiftUI
import EverythingAtOnce

struct NewsListView_Preview: PreviewProvider {

	private static let models: [NewsDisplayModel] = [
		.randomMock(parameters: .all),
		.randomMock(parameters: [.images, .text]),
		.randomMock(parameters: .all),
		.randomMock(parameters: [.text, .category]),
		.randomMock(parameters: .all),
		.randomMock(parameters: [.text])
	]

	static var previews: some View {
		UIViewPreview {
			let view = NewsListView(frame: .zero)
			view.set(newsDisplayModels: models)
			return view
		}
	}

}
#endif
