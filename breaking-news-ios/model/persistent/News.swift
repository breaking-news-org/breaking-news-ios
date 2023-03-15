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

// MARK: - Model

struct News {

	// MARK: Persisted properties

	var id: String

	var creator: String

	var creationDate: Date

	var title: String

	var text: String?

	var category: String?

	var imageUrls: [URL]

	var isPublished: Bool?

	// MARK: Init

	init(id: String, creator: String, creationDate: Date, title: String, text: String? = nil, category: String? = nil, imageUrls: [URL], isPublished: Bool? = nil) {
		self.id = id
		self.creator = creator
		self.creationDate = creationDate
		self.title = title
		self.text = text
		self.category = category
		self.imageUrls = imageUrls
		self.isPublished = isPublished
	}

}

// MARK: - Decodable

extension News: Decodable {

	private enum CodingKeys: String, CodingKey {
		case id
		case creator
		case creationDate
		case title
		case text
		case category
		case imageUrls
		case isPublished
	}

	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)

		self.id = try container.decode(String.self, forKey: .id)
		self.creator = try container.decode(String.self, forKey: .creator)
		self.title = try container.decode(String.self, forKey: .title)
		self.text = try container.decodeIfPresent(String.self, forKey: .text)
		self.category = try container.decodeIfPresent(String.self, forKey: .title)
		self.isPublished = try container.decodeIfPresent(Bool.self, forKey: .isPublished)

		let dateString: String = try container.decode(String.self, forKey: .creationDate)
		self.creationDate = DateFormatters.utc.date(from: dateString)!

		let imageUrlStrings: [String] = try container.decode([String].self, forKey: .imageUrls)
		self.imageUrls = imageUrlStrings.compactMap(URL.init(string:))
	}

}
