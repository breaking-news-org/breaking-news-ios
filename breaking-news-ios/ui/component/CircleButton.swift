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

// MARK: - View

struct CircleButton<Content: View>: View {

	// MARK: Private properties

	private let action: () -> Void

	@ViewBuilder private let content: () -> Content

	// MARK: Init

	init(
		action: @escaping () -> Void,
		@ViewBuilder label content: @escaping () -> Content
	) {
		self.action = action
		self.content = content
	}

	// MARK: - Body

	var body: some View {
		Button {
			action()
		} label: {
			GeometryReader { geometry in
				content()
					.frame(
						width: 0.5 * geometry.size.width,
						height: 0.5 * geometry.size.height
					)
					.frame(
						maxWidth: .infinity,
						maxHeight: .infinity
					)
			}
			.background(Asset.Colors.babyPowder.swiftUIColor)
			.clipShape(Capsule(style: .circular))
			.shadow(
				color: Asset.Colors.ashGray.swiftUIColor.opacity(0.5),
				radius: Padding.xs,
				y: Padding.xxs
			)
			.contentShape(Rectangle())
		}
		.scaleOnPress()
	}

}

// MARK: - Previews

#if DEBUG
struct CircleButton_Previews: PreviewProvider {

	static var previews: some View {
		VStack(spacing: 30) {
			ForEach([16, 20, 24, 28, 32, 36, 40, 50], id: \.self) { side in
				CircleButton {

				} label: {
					Asset.Images.backArrow.swiftUIImage
						.resizable()
						.renderingMode(.template)
						.foregroundColor(.red)
				}
				.frame(size: .square(side))
			}
		}
	}

}
#endif
