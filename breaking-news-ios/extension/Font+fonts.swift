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

extension SwiftUI.Font {

	// Regular

	/// Regular of size 32.
	static let h1Regular: SwiftUI.Font = .default(32, .regular)

	/// Regular of size 24.
	static let h2Regular: SwiftUI.Font = .default(24, .regular)

	/// Regular of size 18.
	static let h3Regular: SwiftUI.Font = .default(18, .regular)

	/// Regular of size 16.
	static let h4Regular: SwiftUI.Font = .default(16, .regular)

	/// Regular of size 14.
	static let h5Regular: SwiftUI.Font = .default(14, .regular)

	/// Regular of size 12.
	static let h6Regular: SwiftUI.Font = .default(12, .regular)

	/// Regular of size 10.
	static let h7Regular: SwiftUI.Font = .default(10, .regular)

	// Medium

	/// Medium of size 32.
	static let h1Medium: SwiftUI.Font = .default(32, .medium)

	/// Medium of size 24.
	static let h2Medium: SwiftUI.Font = .default(24, .medium)

	/// Medium of size 18.
	static let h3Medium: SwiftUI.Font = .default(18, .medium)

	/// Medium of size 16.
	static let h4Medium: SwiftUI.Font = .default(16, .medium)

	/// Medium of size 14.
	static let h5Medium: SwiftUI.Font = .default(14, .medium)

	/// Medium of size 12.
	static let h6Medium: SwiftUI.Font = .default(12, .medium)

	/// Medium of size 10.
	static let h7Medium: SwiftUI.Font = .default(10, .medium)

	// Bold

	/// Bold of size 32.
	static let h1Bold: SwiftUI.Font = .default(32, .bold)

	/// Bold of size 24.
	static let h2Bold: SwiftUI.Font = .default(24, .bold)

	/// Bold of size 18.
	static let h3Bold: SwiftUI.Font = .default(18, .bold)

	/// Bold of size 16.
	static let h4Bold: SwiftUI.Font = .default(16, .bold)

	/// Bold of size 14.
	static let h5Bold: SwiftUI.Font = .default(14, .bold)

	/// Bold of size 12.
	static let h6Bold: SwiftUI.Font = .default(12, .bold)

	/// Bold of size 10.
	static let h7Bold: SwiftUI.Font = .default(10, .bold)

	// Default

	/// Default app font of specific size and weight.
	private static func `default`(
		_ size: CGFloat,
		_ weight: SwiftUI.Font.Weight
	) -> SwiftUI.Font {
		switch weight {
		case .regular:
			return FontFamily.Roboto.regular.swiftUIFont(fixedSize: size)
		case .medium:
			return FontFamily.Roboto.medium.swiftUIFont(fixedSize: size)
		case .bold:
			return FontFamily.Roboto.bold.swiftUIFont(fixedSize: size)
		default:
			log.error("Cannot find Roboto font of size \(size) and weight \(weight). System one will be used.")
			return .system(size: size, weight: weight)
		}
	}

}
