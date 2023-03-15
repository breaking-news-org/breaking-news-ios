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

	var searchEditingEnd: AnyPublisher<Void, Never> {
		return _searchEditingEnd.eraseToAnyPublisher()
	}

	var didTapProfile: AnyPublisher<Void, Never> {
		return profileButton.pressGesturePublisher
			.mapEmpty()
			.eraseToAnyPublisher()
	}

	var didSelectDisplayModel: AnyPublisher<NewsDisplayModel, Never> {
		return _didSelectNewsModel.eraseToAnyPublisher()
	}

	var didTapCreateNews: AnyPublisher<Void, Never> {
		return createButton.pressGesturePublisher
			.mapEmpty()
			.eraseToAnyPublisher()
	}

	// MARK: Private properties

	@Published private var _searchString: String = ""

	@Published private var _models: [NewsDisplayModel] = []

	private let _searchEditingEnd: PassthroughSubject<Void, Never> = PassthroughSubject()

	private let _didSelectNewsModel: PassthroughSubject<NewsDisplayModel, Never> = PassthroughSubject()

	// MARK: Subviews

	private lazy var loadingBlurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
		.setAlpha(0.3)
		.setHidden(true)

	private lazy var loadingIndicatorView = UIActivityIndicatorView(frame: .zero)
		.setHidesWhenStopped(true)
		.setColor(Asset.Colors.babyPowder.color)
		.setTransform(.scale(2))

	private lazy var profileLabel = UILabel(frame: .zero)
		.setText(Lorem.fullname)
		.setFont(.h4Bold)
		.setTextColor(Asset.Colors.blackBean.color)
		.setNumberOfLines(1)

	private lazy var profileButton = ShadowedButton(frame: .zero)
		.setImage(Asset.Images.user.image, forState: .normal)
		.setTintColor(Asset.Colors.blackBean.color)
		.setBackgroundColor(Asset.Colors.babyPowder.color)

	private lazy var createButton = ShadowedButton(frame: .zero)
		.setImage(Asset.Images.edit.image, forState: .normal)
		.setTintColor(Asset.Colors.blackBean.color)
		.setBackgroundColor(Asset.Colors.babyPowder.color)

	private lazy var searchTextField = UITextField(frame: .zero)
		.setDelegate(self)
		.setPlaceholder("Type to search...")

	private lazy var tableView: UITableView = UITableView(frame: .zero)
		.setDataSource(self)
		.setDelegate(self)
		.setSeparatorStyle(.none)
		.setAllowsSelection(true)
		.setAllowsMultipleSelection(false)
		.setRegistered(cellClass: NewsListCell.self)
		.setAutomaticallyAdjustsScrollIndicatorInsets(true)

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
			VerticalStack(spacing: 12) {
				UIView {
					profileButton.withConstraints {
						pinLeading(toSuperview: .leading, offset: 20)
						pinCenterY(toSuperview: .centerY)
						pinWidth(to: 50)
						pinHeight(to: 50)
					}

					createButton.withConstraints {
						pinTrailing(toSuperview: .trailing, offset: -20)
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
					pinHeight(to: 85)
					pinLeading(toSuperview: .leading)
					pinTrailing(toSuperview: .trailing)
				}

				UIView {
					HorizontalStack(spacing: 8, alignment: .center) {
						UIImageView(frame: .zero)
							.setImage(UIImage(systemName: "magnifyingglass")?.withRenderingMode(.alwaysTemplate))
							.setTintColor(Asset.Colors.ashGray.color)
							.withConstraints {
								pinHeight(to: 20)
								pinWidth(to: 20)
							}

						searchTextField.withConstraints {
							pinCenterY(toSuperview: .centerY)
							pinWidth(to: CGFloat.greatestFiniteMagnitude, priority: .defaultLow)
						}
					}
					.withConstraints {
						pinTop(toSuperview: .top)
						pinBottom(toSuperview: .bottom)
						pinLeading(toSuperview: .leading, offset: 12)
						pinTrailing(toSuperview: .trailing, offset: -12)
					}
				}
				.setLayerCornerRadius(14)
				.setLayerBorderColor(Asset.Colors.ashGray.color)
				.setLayerBorderWidth(1)
				.withConstraints {
					pinHeight(to: 44)
					pinLeading(toSuperview: .leading, offset: 20)
					pinTrailing(toSuperview: .trailing, offset: -20)
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

			loadingBlurEffectView.withConstraints {
				pinTop(toSuperview: .top)
				pinBottom(toSuperview: .bottom)
				pinLeading(toSuperview: .leading)
				pinTrailing(toSuperview: .trailing)
			}

			loadingIndicatorView.withConstraints {
				pinCenterX(toSuperview: .centerX)
				pinCenterY(toSuperview: .centerY)
			}
		}
	}

	// MARK: Exposed methods

	func set(state: NewsListScreenState) {
		let isLoading: Bool = (state == .loading)

		isUserInteractionEnabled = not(isLoading)

		UIView.transition(
			with: self,
			duration: 0.2,
			options: [.showHideTransitionViews, .transitionCrossDissolve, .curveEaseInOut]
		) { [weak self] in
			switch state {
			case .loading:
				self?.loadingBlurEffectView.isHidden = false
				self?.loadingIndicatorView.startAnimating()
			case .normal:
				self?.loadingBlurEffectView.isHidden = true
				self?.loadingIndicatorView.stopAnimating()
			}
		}
	}

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

	func tableView(
		_ tableView: UITableView,
		didSelectRowAt indexPath: IndexPath
	) {
		defer {
			tableView.deselectRow(at: indexPath, animated: false)
		}
		_didSelectNewsModel.send(_models[indexPath.row])
	}

}

// MARK: - UISearchBarDelegate

extension NewsListView: UITextFieldDelegate {

	func textFieldDidEndEditing(_ textField: UITextField) {
		_searchEditingEnd.send()
	}

	func textField(
		_ textField: UITextField,
		shouldChangeCharactersIn range: NSRange,
		replacementString string: String
	) -> Bool {
		let currentText: String = textField.text.unwrapped(or: .emptyString)

		guard let stringRange = Range(range, in: currentText) else {
			return false
		}

		let updatedText: String = currentText
			.replacingCharacters(
				in: stringRange,
				with: string
			)
			.replacingOccurrences(
				of: "\n",
				with: " "
			)

		guard updatedText != currentText else {
			return false
		}

		textField.text = updatedText
		_searchString = updatedText

		return false
	}

}

// MARK: - Preview

#if DEBUG
import SwiftUI

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
			view.set(state: .normal)
			return view
		}
		.previewDevice(.iPhone13Pro)
	}

}
#endif
