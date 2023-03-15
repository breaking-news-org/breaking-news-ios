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

import Foundation
import RealmSwift
import EverythingAtOnce

// MARK: - Extension

extension News {

	struct MockParameters: OptionSet {

		let rawValue: Int

		static let images: MockParameters = MockParameters(rawValue: 1 << 1)

		static let text: MockParameters = MockParameters(rawValue: 1 << 2)

		static let category: MockParameters = MockParameters(rawValue: 1 << 3)

		static let all: MockParameters = [.images, .text, .category]

	}

	static func randomMock(parameters: MockParameters = .all) -> News {
		return News(
			id: UUID().uuidString.lowercased(),
			creator: Lorem.fullname,
			creationDate: Date().addingTimeInterval(.random(in: -7_000...0)),
			title: Lorem.sentence(ofLength: 5),
			text: parameters.contains(.text) ? Lorem.paragraph : nil,
			category: parameters.contains(.category) ? Lorem.word : nil,
			imageUrls: parameters.contains(.images) ? [Picsum.random200x200(), Picsum.random200x200()] : [],
			isPublished: [true, false, nil].randomElement()!
		)
	}

}
