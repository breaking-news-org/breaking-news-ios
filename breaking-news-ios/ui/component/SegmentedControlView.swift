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

struct SegmentedControlView<
	SegmentID: Identifiable,
	SegmentContent: View,
	SegmentBackgoundShape: Shape
>: View {

	// MARK: - Private properties

	// Data

	private let segments: [SegmentID]

	@Binding private var selectedSegment: SegmentID

	// Animation

	@Namespace private var animationNamespace

	private let animation: Animation

	// Builder

	@ViewBuilder private let segmentContent: (SegmentID) -> SegmentContent

	@ViewBuilder private let segmentBackgoundShape: () -> SegmentBackgoundShape

	// UI

	private let selectedSegmentBackgoundColor: Color

	private let backgroundColor: Color

	// MARK: - Init

	init(
		segments: [SegmentID],
		selectedSegment: Binding<SegmentID>,
		@ViewBuilder segmentContent: @escaping (SegmentID) -> SegmentContent,
		@ViewBuilder segmentBackgoundShape: @escaping () -> SegmentBackgoundShape,
		animation: Animation = .interactiveSpring(),
		backgoundColor: Color = .white,
		selectedSegmentBackgoundColor: Color = .white
	) {
		self._selectedSegment = selectedSegment
		self.animation = animation
		self.segments = segments
		self.segmentContent = segmentContent
		self.segmentBackgoundShape = segmentBackgoundShape
		self.selectedSegmentBackgoundColor = selectedSegmentBackgoundColor
		self.backgroundColor = backgoundColor
	}

	// MARK: - Body

	var body: some View {
		GeometryReader { geometry in
			ZStack {
				segmentBackgoundShape()
					.fill(backgroundColor)

				HStack(alignment: .center, spacing: .zero) {
					ForEach(segments) { segment in
						segmentView(segment: segment)
					}
					.frame(
						width: (geometry.size.width - 2*Padding.xxs) / CGFloat(segments.count)
					)
				}
				.padding(.all, Padding.xxs)
			}
		}
	}

	// MARK: - Private methods

	private func segmentIndex(
		offsetWidth: CGFloat,
		totalWidth: CGFloat
	) -> Int {
		let fractionComplete = offsetWidth / totalWidth
		let index = Int(fractionComplete * CGFloat(segments.count))
		return max(.zero, min(segments.count - 1, index))
	}

	private func isSelected(segment: SegmentID) -> Bool {
		return segment.id == selectedSegment.id
	}

	@ViewBuilder private func segmentView(
		segment: SegmentID
	) -> some View {
		GeometryReader { geometry in
			ZStack {
				if isSelected(segment: segment) {
					segmentBackgoundShape()
						.fill(selectedSegmentBackgoundColor)
						.matchedGeometryEffect(
							id: "segment.selected",
							in: animationNamespace
						)
				}

				segmentContent(segment)
					.frame(size: geometry.size)
			}
		}
		.contentShape(Rectangle())
		.onTapGesture {
			withAnimation(animation) {
				selectedSegment = segment
			}
		}
	}

}

// MARK: - Previews

#if DEBUG
private typealias OptionString = String
private typealias OptionBool = Bool

extension OptionString: Identifiable {
	public var id: String {
		return self
	}
}

extension OptionBool: Identifiable {
	public var id: String {
		return self.description
	}
}

private struct SegmentedControlView_PreviewContentView: View {

	private let strings: [OptionString] = ["Picsum", "Lorem", "Manual", "None"]

	@State private var selectedString: OptionString = "Lorem"

	@State private var selectedBool: Bool = false

	var body: some View {
		VStack(spacing: 60) {
			Text(selectedString)
				.lineLimit(1)
				.font(.system(size: 26, weight: .bold))
				.foregroundColor(.blue.opacity(0.5))

			SegmentedControlView(
				segments: strings,
				selectedSegment: $selectedString
			) { string in
				Text(string)
					.lineLimit(1)
					.font(.system(size: 16, weight: .bold))
					.foregroundColor(selectedString == string ? .black : .black.opacity(0.5))
			} segmentBackgoundShape: {
				RoundedRectangle(cornerRadius: 12)
			}
			.frame(width: 300, height: 60)
		}
	}

}

struct SegmentedControlView_Previews: PreviewProvider {

	static var previews: some View {
		SegmentedControlView_PreviewContentView()
	}

}
#endif
