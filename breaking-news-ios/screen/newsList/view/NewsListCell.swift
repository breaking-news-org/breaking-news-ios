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
import Kingfisher
import EverythingAtOnce

// MARK: - Subview

final class NewsListCell: BaseTableViewCell {

	// MARK: Exposed properties

	static let preferredHeight: CGFloat = 16 + 93 + 16

	// MARK: Subviews

	private lazy var titleLabel: UILabel = UILabel(frame: .zero)
		.setFont(.p2Bold)
		.setTextColor(Asset.Colors.blackBean.color)
		.setNumberOfLines(2)

	private lazy var previewImageView: UIImageView = UIImageView(frame: .zero)
		.setContentMode(.scaleAspectFill)
		.setLayerCornerRadius(8)
		.setLayerMasksToBounds(true)

	private lazy var calendarImageView: UIImageView = UIImageView(frame: .zero)
		.setImage(Asset.Images.calendar.image)
		.setTintColor(Asset.Colors.battleshipGray.color)
		.setContentMode(.scaleAspectFit)

	private lazy var calendarDateLabel: UILabel = UILabel(frame: .zero)
		.setTextColor(Asset.Colors.battleshipGray.color)
		.setFont(.p3Medium)

	private lazy var clockImageView: UIImageView = UIImageView(frame: .zero)
		.setImage(Asset.Images.clock.image)
		.setTintColor(Asset.Colors.battleshipGray.color)
		.setContentMode(.scaleAspectFit)

	private lazy var clockDateLabel: UILabel = UILabel(frame: .zero)
		.setTextColor(Asset.Colors.battleshipGray.color)
		.setFont(.p3Medium)

	// MARK: Lifecycle

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		selectionStyle = .none
	}

	override func setupSubviewHierarchy() {
		super.setupSubviewHierarchy()
		contentView.addSubviews {
			HorizontalStack(spacing: 17, alignment: .center) {

				previewImageView.withConstraints {
					pinTop(toSuperview: .top)
					pinBottom(toSuperview: .bottom)
					pinWidth(toSuperview: .width, multiplier: 0.28)
				}

				VerticalStack(spacing: 4, alignment: .leading) {
					titleLabel

					UIView().withConstraints {
						pinHeight(to: CGFloat.greatestFiniteMagnitude, priority: .defaultLow)
					}

					HorizontalStack(spacing: 20, distribution: .fillEqually) {
						HorizontalStack(spacing: 5, alignment: .center) {
							calendarImageView.withConstraints {
								pinWidth(to: 21)
								pinHeight(to: 21)
							}

							calendarDateLabel.withConstraints {
								pinWidth(to: CGFloat.greatestFiniteMagnitude, priority: .defaultHigh)
							}
						}

						HorizontalStack(spacing: 5, alignment: .center) {
							clockImageView.withConstraints {
								pinWidth(to: 18)
								pinHeight(to: 18)
							}

							clockDateLabel.withConstraints {
								pinWidth(to: CGFloat.greatestFiniteMagnitude, priority: .defaultHigh)
							}
						}
					}
				}
				.withConstraints {
					pinWidth(to: CGFloat.greatestFiniteMagnitude, priority: .defaultLow)
					pinTop(toSuperview: .top, offset: 2)
					pinBottom(toSuperview: .bottom, offset: -2)
				}
			}
			.withConstraints {
				pinTop(toSuperview: .top, offset: 16)
				pinBottom(toSuperview: .bottom, offset: -16)
				pinLeading(toSuperview: .leading, offset: 20)
				pinTrailing(toSuperview: .trailing, offset: -20)
				pinHeight(to: 67)
			}
		}
	}

	// MARK: Exposed methods

	func set(newsDisplayModel: NewsDisplayModel) {
		titleLabel.text = newsDisplayModel.title
		calendarDateLabel.text = DateFormatters.dayAndMonth.string(from: newsDisplayModel.creationDate)
		clockDateLabel.text = newsDisplayModel.relativeDateString
		previewImageView.kf.setImage(
			with: newsDisplayModel.imageUrls.first,
			placeholder: Asset.Images.emptyImage.image
		)
	}

}
