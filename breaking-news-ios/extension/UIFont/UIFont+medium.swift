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

	/// Medium primary font of specified size.
	static func medium(ofSize size: CGFloat) -> UIFont {
		return .primary(ofSize: size, .medium)
	}

	/// Medium primary font of size 32. Use for headings.
	static let h1Medium: UIFont = .medium(ofSize: 32)

	/// Medium primary font of size 26. Use for headings.
	static let h2Medium: UIFont = .medium(ofSize: 26)

	/// Medium primary font of size 22. Use for headings.
	static let h3Medium: UIFont = .medium(ofSize: 22)

	/// Medium primary font of size 20. Use for headings.
	static let h4Medium: UIFont = .medium(ofSize: 20)

	/// Medium primary font of size 18. Use for headings.
	static let h5Medium: UIFont = .medium(ofSize: 18)

	/// Medium primary font of size 16. Use for paragraphs.
	static let p1Medium: UIFont = .medium(ofSize: 16)

	/// Medium primary font of size 14. Use for paragraphs.
	static let p2Medium: UIFont = .medium(ofSize: 14)

	/// Medium primary font of size 12. Use for paragraphs.
	static let p3Medium: UIFont = .medium(ofSize: 12)

	/// Medium primary font of size 10. Use for paragraphs.
	static let p4Medium: UIFont = .medium(ofSize: 10)

}
