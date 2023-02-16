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

// MARK: - Model

struct NewsDisplayModel {

	// MARK: Exposed properties

	let id: String

	let creator: String

	let creationDate: Date

	let title: String

	let text: String?

	let category: String?

	let imageUrls: [URL]

	let isPublished: Bool?

	// MARK: Init

	init(
		id: String,
		creator: String,
		creationDate: Date,
		title: String,
		text: String?,
		category: String?,
		imageUrls: [URL],
		isPublished: Bool?
	) {
		self.id = id
		self.creator = creator
		self.creationDate = creationDate
		self.title = title
		self.text = text
		self.category = category
		self.imageUrls = imageUrls
		self.isPublished = isPublished
	}

	init(from model: News) {
		self.id = model.id
		self.creator = model.creator
		self.creationDate = model.creationDate
		self.title = model.title
		self.text = model.text
		self.category = model.creator
		self.imageUrls = Array(model.imageUrls)
		self.isPublished = model.isPublished
	}

}
