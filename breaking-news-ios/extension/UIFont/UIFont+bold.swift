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

	/// Bold primary font of specified size.
	static func bold(ofSize size: CGFloat) -> UIFont {
		return .primary(ofSize: size, .bold)
	}

	/// Bold primary font of size 32. Use for headings.
	static let h1Bold: UIFont = .bold(ofSize: 32)

	/// Bold primary font of size 26. Use for headings.
	static let h2Bold: UIFont = .bold(ofSize: 26)

	/// Bold primary font of size 22. Use for headings.
	static let h3Bold: UIFont = .bold(ofSize: 22)

	/// Bold primary font of size 20. Use for headings.
	static let h4Bold: UIFont = .bold(ofSize: 20)

	/// Bold primary font of size 18. Use for headings.
	static let h5Bold: UIFont = .bold(ofSize: 18)

	/// Bold primary font of size 16. Use for paragraphs.
	static let p1Bold: UIFont = .bold(ofSize: 16)

	/// Bold primary font of size 14. Use for paragraphs.
	static let p2Bold: UIFont = .bold(ofSize: 14)

	/// Bold primary font of size 12. Use for paragraphs.
	static let p3Bold: UIFont = .bold(ofSize: 12)

	/// Bold primary font of size 10. Use for paragraphs.
	static let p4Bold: UIFont = .bold(ofSize: 10)

}
