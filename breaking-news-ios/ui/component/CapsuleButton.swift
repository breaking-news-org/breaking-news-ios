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
import EverythingAtOnce

// MARK: - Button

/// `BaseButton` subclass that makes the corner radius equal to the smallest side of the button.
class CapsuleButton: BaseButton {

	override func layoutSubviews() {
		super.layoutSubviews()

		let shapeLayer: CAShapeLayer

		if let existingLayer = layer.mask as? CAShapeLayer {
			shapeLayer = existingLayer
		} else {
			shapeLayer = CAShapeLayer()
			layer.mask = shapeLayer
		}

		shapeLayer.path = UIBezierPath(
			roundedRect: bounds,
			cornerRadius: (0.5) * bounds.size.minDimension
		)
		.cgPath
	}

}
