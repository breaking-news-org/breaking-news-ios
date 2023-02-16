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

// MARK: - Font

extension UIFont {

	/// Returns the font object for the primary family of the application in the specified size and weight.
	///
	/// - Warning: The provided family might miss some system font weights. Check the bundle and the *Info.plist* for the available ones.
	static func primary(ofSize size: CGFloat, _ weight: UIFont.Weight) -> UIFont {
		switch weight {
		case .regular:
			return FontFamily.Roboto.regular.font(size: size)
		case .medium:
			return FontFamily.Roboto.medium.font(size: size)
		case .bold:
			return FontFamily.Roboto.bold.font(size: size)
		default:
			fatalError("Invalid font weight for family \"Roboto\"")
		}
	}

}
