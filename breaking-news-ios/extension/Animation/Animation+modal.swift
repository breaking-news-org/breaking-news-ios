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
import XCoordinator

// MARK: - Animation

extension Animation {

	static let modal = Animation(
		presentation: InteractiveTransitionAnimation.modalPresentation,
		dismissal: InteractiveTransitionAnimation.modalDismissal
	)

}

// MARK: - Interactive animation

extension InteractiveTransitionAnimation {

	fileprivate static let duration: TimeInterval = 0.35

	fileprivate static let modalPresentation = InteractiveTransitionAnimation(
		duration: duration,
		transition: { context in
			guard
				let toView = context.view(forKey: .to),
				let fromView = context.view(forKey: .from)
			else {
				return
			}

			var startToFrame = fromView.frame
			startToFrame.origin.y += startToFrame.height
			context.containerView.addSubview(toView)
			context.containerView.bringSubviewToFront(toView)
			toView.frame = startToFrame

			UIView.animate(
				withDuration: duration,
				animations: {
					toView.frame = fromView.frame
				},
				completion: { _ in
					context.completeTransition(!context.transitionWasCancelled)
				}
			)
		}
	)

	fileprivate static let modalDismissal = InteractiveTransitionAnimation(
		duration: duration,
		transition: { context in
			guard
				let toView = context.view(forKey: .to),
				let fromView = context.view(forKey: .from)
			else { return }

			context.containerView.addSubview(toView)
			context.containerView.sendSubviewToBack(toView)
			var newFromFrame = toView.frame
			newFromFrame.origin.y += toView.frame.height

			UIView.animate(
				withDuration: duration,
				animations: {
					fromView.frame = newFromFrame
				},
				completion: { _ in
					context.completeTransition(!context.transitionWasCancelled)
				}
			)
		}
	)

}
