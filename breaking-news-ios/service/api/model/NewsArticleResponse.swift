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

// MARK: - Model

struct NewsArticleResponse: Decodable {

	// MARK: Exposed properties

	let id: Int

	let text: String

	let title: String

	let authorName: String

	let category: Int

	let isPublished: Bool

	let images: [String]

	let creationDate: Date

	// MARK: Init
	
	init(
		id: Int,
		text: String,
		title: String,
		authorName: String,
		category: Int,
		isPublished: Bool,
		images: [String],
		creationDate: Date
	) {
		self.id = id
		self.text = text
		self.title = title
		self.authorName = authorName
		self.category = category
		self.isPublished = isPublished
		self.images = images
		self.creationDate = creationDate
	}

	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)

		self.id = try container.decode(Int.self, forKey: .id)
		self.text = try container.decode(String.self, forKey: .text)
		self.title = try container.decode(String.self, forKey: .title)
		self.authorName = try container.decode(String.self, forKey: .authorName)
		self.category = try container.decode(Int.self, forKey: .category)
		self.isPublished = try container.decode(Bool.self, forKey: .isPublished)
		self.images = try container.decode([String].self, forKey: .images)

		let creationDateString = try container.decode(String.self, forKey: .creationDate)

		guard
			let creationDate = Formatters.iso8601DateFormatter.date(from: creationDateString)
		else {
			throw DecodingError.dataCorrupted(DecodingError.Context(
				codingPath: [CodingKeys.creationDate],
				debugDescription: "Date string \"\(creationDateString)\" does not satisfy format options \(Formatters.iso8601DateFormatter.formatOptions)."
			))
		}

		self.creationDate = creationDate
	}

	// MARK: Coding keys

	private enum CodingKeys: String, CodingKey {
		case id = "id"
		case text = "text"
		case title = "title"
		case authorName = "authorName"
		case category = "category"
		case isPublished = "isPublished"
		case images = "images"
		case creationDate = "createdAt"
	}

}
