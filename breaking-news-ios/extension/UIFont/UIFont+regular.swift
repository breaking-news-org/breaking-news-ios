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

	/// Regular primary font of specified size.
	static func regular(ofSize size: CGFloat) -> UIFont {
		return .primary(ofSize: size, .regular)
	}

	/// Regular primary font of size 32. Use for headings.
	static let h1Regular: UIFont = .regular(ofSize: 32)

	/// Regular primary font of size 26. Use for headings.
	static let h2Regular: UIFont = .regular(ofSize: 26)

	/// Regular primary font of size 22. Use for headings.
	static let h3Regular: UIFont = .regular(ofSize: 22)

	/// Regular primary font of size 20. Use for headings.
	static let h4Regular: UIFont = .regular(ofSize: 20)

	/// Regular primary font of size 18. Use for headings.
	static let h5Regular: UIFont = .regular(ofSize: 18)

	/// Regular primary font of size 16. Use for paragraphs.
	static let p1Regular: UIFont = .regular(ofSize: 16)

	/// Regular primary font of size 14. Use for paragraphs.
	static let p2Regular: UIFont = .regular(ofSize: 14)

	/// Regular primary font of size 12. Use for paragraphs.
	static let p3Regular: UIFont = .regular(ofSize: 12)

	/// Regular primary font of size 10. Use for paragraphs.
	static let p4Regular: UIFont = .regular(ofSize: 10)

}
