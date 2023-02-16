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
import EverythingAtOnce

// MARK: - Button

/// Base class for custom buttons.
class BaseButton: UIButton {

	// MARK: Exposed properties

	/// Button transform for normal state.
	var transformForNormal: CGAffineTransform = .identity

	/// Button transform during the tap/press interaction.
	var transfromForInteraction: CGAffineTransform = .scale(0.94)

	/// Duration of the transform switching at tap/press interaction.
	var longPressGestureTransformDuration: TimeInterval = 0.1

	/// Press recognizer margins.
	var pressGestureMargins: CGFloat = 10

	/// Publishes events at the end of long press interaction.
	/// Since `minimumPressDuration = 0.0`, it emits events at taps too.
	var pressGesturePublisher: AnyPublisher<BaseButton, Never> {
		return _pressGesturePublisher.eraseToAnyPublisher()
	}

	// MARK: Private properties

	private let _pressGesturePublisher: PassthroughSubject<BaseButton, Never> = .init()

	// MARK: Init

	override init(frame: CGRect) {
		super.init(frame: frame)

		let longPressGesture = UILongPressGestureRecognizer()
		longPressGesture.minimumPressDuration = 0.0
		longPressGesture.addTarget(self, action: #selector(onLongPress(_:)))
		addGestureRecognizer(longPressGesture)
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: Override

	override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
		let newBounds = bounds.insetBy(
			dx: -pressGestureMargins,
			dy: -pressGestureMargins
		)
		return newBounds.contains(point)
	}

	// MARK: Setter methods

	@discardableResult func setPressGestureMargins(_ margins: CGFloat) -> Self {
		pressGestureMargins = margins
		return self
	}

	// MARK: Gesture selector

	/// Long press interaction handler.
	@objc private func onLongPress(_ gesture: UILongPressGestureRecognizer) {
		/// Location of the long press gesture in the button.
		let gestureLocation: CGPoint = gesture.location(in: self)

		/// Whether a gesture is currently inside the button bounds.
		let isPointInBounds: Bool = point(inside: gestureLocation, with: nil)

		/// Animations to be perfomed at the start of the gesture.
		let transformAnimationOnStart: () -> Void = { [weak self] in
			self?.transform = self?.transfromForInteraction ?? .identity
		}

		/// Animations to be perfomed at the end of the gesture.
		let transformAnimationOnEnd: () -> Void = { [weak self] in
			self?.transform = self?.transformForNormal ?? .identity
		}

		/// Performed after the gesture finishes with success inside the button.
		let gestureEndCompletion: (Bool) -> Void = { [weak self] completed in

			if completed, let self = self, isPointInBounds {
				self._pressGesturePublisher.send(self)
			}

		}

		switch gesture.state {
		case .began:

			UIView.transition(
				with: self,
				duration: longPressGestureTransformDuration,
				options: .curveLinear,
				animations: transformAnimationOnStart
			)

		case .ended:

			UIView.transition(
				with: self,
				duration: longPressGestureTransformDuration,
				options: .curveLinear,
				animations: transformAnimationOnEnd,
				completion: gestureEndCompletion
			)

		case .cancelled, .failed:

			UIView.transition(
				with: self,
				duration: longPressGestureTransformDuration,
				options: .curveLinear,
				animations: transformAnimationOnEnd
			)

		case .changed:

			if not(isPointInBounds) {
				gesture.isEnabled = false
				gesture.isEnabled = true
			}

		case .possible:
			break
		@unknown default:
			break
		}
	}

}
