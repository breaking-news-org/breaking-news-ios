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

// MARK: - Path

/// Creates a rounded rectangle path for the given rectangle using corner radii for each corner.
func roundedRectanglePath(
	minXminYRadius: CGFloat = 0,
	maxXminYRadius: CGFloat = 0,
	maxXmaxYRadius: CGFloat = 0,
	minXmaxYRadius: CGFloat = 0,
	in rect: CGRect
) -> UIBezierPath {
	let path = UIBezierPath()
	path.move(to: CGPoint(x: minXminYRadius, y: 0))
	path.addLine(to: CGPoint(x: rect.width - maxXminYRadius, y: 0))
	path.addArc(
		withCenter: CGPoint(x: rect.width - maxXminYRadius, y: maxXminYRadius),
		radius: maxXminYRadius,
		startAngle: (3/2) * .pi,
		endAngle: (0) * .pi,
		clockwise: true
	)
	path.addLine(to: CGPoint(x: rect.width, y: rect.height - maxXmaxYRadius))
	path.addArc(
		withCenter: CGPoint(x: rect.width - maxXmaxYRadius, y: rect.height - maxXmaxYRadius),
		radius: maxXmaxYRadius,
		startAngle: (0) * .pi,
		endAngle: (1/2) * .pi,
		clockwise: true
	)
	path.addLine(to: CGPoint(x: minXmaxYRadius, y: rect.height))
	path.addArc(
		withCenter: CGPoint(x: minXmaxYRadius, y: rect.height - minXmaxYRadius),
		radius: minXmaxYRadius,
		startAngle: (1/2) * .pi,
		endAngle: (1) * .pi,
		clockwise: true
	)
	path.addLine(to: CGPoint(x: 0, y: minXminYRadius))
	path.addArc(
		withCenter: CGPoint(x: minXminYRadius, y: minXminYRadius),
		radius: minXminYRadius,
		startAngle: (1) * .pi,
		endAngle: (3/2) * .pi,
		clockwise: true
	)
	path.close()
	return path
}

// MARK: - Preview

#if DEBUG
import SwiftUI
import EverythingAtOnce

struct RoundedRectanglePath_Previews: PreviewProvider {

	private final class DummyAlertView: BaseView {

		override func layoutSubviews() {
			super.layoutSubviews()

			let shapeLayer: CAShapeLayer

			if let existingLayer = layer.mask as? CAShapeLayer {
				shapeLayer = existingLayer
			} else {
				shapeLayer = CAShapeLayer()
				layer.mask = shapeLayer
			}

			shapeLayer.path = roundedRectanglePath(
				minXminYRadius: 80,
				maxXminYRadius: 60,
				maxXmaxYRadius: 40,
				minXmaxYRadius: 10,
				in: bounds
			).cgPath

		}

	}

	static var previews: some View {
		ZStack {
			Color.black
			UIViewPreview {
				DummyAlertView(frame: .zero)
					.setBackgroundColor(.white)
			}
			.frame(width: 300, height: 160)
		}
		.edgesIgnoringSafeArea(.all)
		.previewDevice(.iPhone11)
	}

}
#endif
