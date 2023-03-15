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

// MARK: - View

/// Base class for custom views.
class BaseView: UIView {

	// MARK: Exposed properties

	/// Storage for the subscriptions.
	final var disposeBag: Set<AnyCancellable> = []

	// MARK: Lifecycle

	override init(frame: CGRect) {
		super.init(frame: frame)
		backgroundColor = .clear
		setupSubviewHierarchy()
		setupSubviewBindings()
		makeAccessibilityIdentifiersForChildren()
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: Methods

	/// Setups initial subview hierarchy. Should be called once.
	func setupSubviewHierarchy() {

	}

	/// Setups subview bindings. Should be called once.
	func setupSubviewBindings() {

	}

}
