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

final class NewsDetailsView: BaseView {

	// MARK: Private properties

	var didTapBack: AnyPublisher<Void, Never> {
		return backButton.pressGesturePublisher
			.mapEmpty()
			.eraseToAnyPublisher()
	}

	var didTapShare: AnyPublisher<Void, Never> {
		return shareButton.pressGesturePublisher
			.mapEmpty()
			.eraseToAnyPublisher()
	}

	// MARK: Subviews

	private lazy var backButton = ShadowedButton(frame: .zero)
		.setImage(Asset.Images.backArrow.image, forState: .normal)
		.setTintColor(Asset.Colors.blackBean.color)
		.setBackgroundColor(Asset.Colors.babyPowder.color)

	private lazy var shareButton = ShadowedButton(frame: .zero)
		.setImage(Asset.Images.share.image, forState: .normal)
		.setTintColor(Asset.Colors.blackBean.color)
		.setBackgroundColor(Asset.Colors.babyPowder.color)

	private lazy var relativeDateLabel = UILabel(frame: .zero)
		.setFont(.h4Bold)
		.setTextColor(Asset.Colors.blackBean.color)
		.setNumberOfLines(1)
		.setTextAlignment(.center)

	private lazy var authorLabel = UILabel(frame: .zero)
		.setFont(.p1Bold)
		.setTextColor(Asset.Colors.blackBean.color)
		.setNumberOfLines(1)

	private lazy var authorImageView = UIImageView(frame: .zero)
		.setContentMode(.scaleAspectFit)
		.setLayerMasksToBounds(true)

	private lazy var contentImageView = UIImageView(frame: .zero)
		.setContentMode(.scaleAspectFill)
		.setLayerMasksToBounds(true)

	private lazy var creationLabel = UILabel(frame: .zero)
		.setFont(.p4Bold)
		.setTextColor(Asset.Colors.blackBean.color)
		.setNumberOfLines(1)
		.setTextAlignment(.right)

	private lazy var titleLabel = UILabel(frame: .zero)
		.setFont(.h4Bold)
		.setTextColor(Asset.Colors.blackBean.color)
		.setNumberOfLines(3)
		.setTextAlignment(.left)

	private lazy var contentLabel = UILabel(frame: .zero)
		.setFont(.p1Regular)
		.setTextColor(Asset.Colors.gunmetal.color)
		.setNumberOfLines(0)
		.setTextAlignment(.natural)

	// MARK: Init

	override init(frame: CGRect) {
		super.init(frame: frame)
		backgroundColor = Asset.Colors.babyPowder.color
	}

	// MARK: Override

	override func setupSubviewHierarchy() {
		super.setupSubviewHierarchy()
		addSubviews {
			UIView {
				backButton.withConstraints {
					pinLeading(toSuperview: .leading, offset: 20)
					pinCenterY(toSuperview: .centerY)
					pinWidth(to: 40)
					pinHeight(to: 40)
				}

				shareButton.withConstraints {
					pinTrailing(toSuperview: .trailing, offset: -20)
					pinCenterY(toSuperview: .centerY)
					pinWidth(to: 40)
					pinHeight(to: 40)
				}

				relativeDateLabel.withConstraints {
					pinCenterY(toSuperview: .centerY)
					pinLeading(to: .trailing, of: backButton, offset: 16)
					pinTrailing(to: .leading, of: shareButton, offset: -16)
				}
			}
			.withConstraints {
				pinHeight(to: 85)
				pinTop(to: .top, of: safeAreaLayoutGuide)
				pinLeading(toSuperview: .leading)
				pinTrailing(toSuperview: .trailing)
			}

			UIScrollView {
				VerticalStack(spacing: 18) {
					contentImageView.withConstraints { [self] in
						pinHeight(to: .width, of: contentImageView, multiplier: 0.65)
						pinLeading(toSuperview: .leading, offset: 20)
						pinTrailing(toSuperview: .trailing, offset: -20)
					}
					.setLayerCornerRadius(33)

					titleLabel.withConstraints {
						pinLeading(toSuperview: .leading, offset: 20)
						pinTrailing(toSuperview: .trailing, offset: -20)
					}

					UIView {
						authorImageView.withConstraints {
							pinLeading(toSuperview: .leading, offset: 20)
							pinCenterY(toSuperview: .centerY)
							pinWidth(to: 50)
							pinHeight(to: 50)
						}
						.setLayerCornerRadius(25)

						creationLabel.withConstraints {
							pinTrailing(toSuperview: .trailing, offset: -20)
							pinBottom(toSuperview: .bottom)
							pinWidth(to: 50)
						}

						authorLabel.withConstraints { [self] in
							pinCenterY(toSuperview: .centerY)
							pinLeading(to: .trailing, of: authorImageView, offset: 12)
							pinTrailing(to: .leading, of: creationLabel, offset: -12)
						}
					}
					.withConstraints {
						pinHeight(to: 60)
						pinLeading(toSuperview: .leading)
						pinTrailing(toSuperview: .trailing)
					}

					contentLabel.withConstraints {
						pinLeading(toSuperview: .leading, offset: 20)
						pinTrailing(toSuperview: .trailing, offset: -20)
					}

					UIView().withConstraints {
						pinHeight(to: 100)
						pinLeading(toSuperview: .leading)
						pinTrailing(toSuperview: .trailing)
					}
				}
				.withConstraints {
					pinWidth(toSuperview: .width)
					pinTop(toSuperview: .top)
					pinBottom(toSuperview: .bottom)
					pinLeading(toSuperview: .leading)
					pinTrailing(toSuperview: .trailing)
				}
			}
			.withConstraints { [self] in
				pinTop(to: .top, of: safeAreaLayoutGuide, offset: 85)
				pinBottom(toSuperview: .bottom)
				pinLeading(toSuperview: .leading)
				pinTrailing(toSuperview: .trailing)
			}
		}
	}

	// MARK: Exposed methods

	func set(newsDisplayModel: NewsDisplayModel) {
		relativeDateLabel.text = newsDisplayModel.relativeDateString

		contentLabel.text = newsDisplayModel.text
		contentLabel.sizeToFit()

		creationLabel.text = DateFormatters.dayAndMonth.string(from: newsDisplayModel.creationDate)
		creationLabel.sizeToFit()

		authorLabel.text = newsDisplayModel.creator
		authorLabel.sizeToFit()

		titleLabel.text = newsDisplayModel.title
		titleLabel.sizeToFit()

		authorImageView.kf.setImage(with: Picsum.random200x200())

		contentImageView.kf.setImage(with: newsDisplayModel.imageUrls.first)
	}

	// MARK: Private methods

}

// MARK: - Preview

#if DEBUG
import SwiftUI

struct NewsDetailsView_Preview: PreviewProvider {

	private static let model: NewsDisplayModel = NewsDisplayModel(from: News.randomMock(parameters: .all))

	static var previews: some View {
		UIViewPreview {
			let view = NewsDetailsView(frame: .zero)
			view.set(newsDisplayModel: model)
			return view
		}
		.previewDevice(.iPhone11)
	}

}
#endif
