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

import Foundation

// MARK: - APIResponse

enum APIResponse<Left: Decodable, Right: Decodable> {

	// MARK: Cases

	case right(Right)

	case left(Left)

}

extension APIResponse: Decodable {

	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)

		if let left = try container.decodeIfPresent(Left.self, forKey: .left) {
			self = .left(left)
		} else if let right = try container.decodeIfPresent(Right.self, forKey: .right) {
			self = .right(right)
		} else {
			throw DecodingError.dataCorrupted(.init(
				codingPath: [],
				debugDescription: "Cannot get \(CodingKeys.left.rawValue) or \(CodingKeys.right.rawValue)."
			))
		}
	}

	private enum CodingKeys: String, CodingKey {
		case right = "Right"
		case left = "Left"
	}

}
