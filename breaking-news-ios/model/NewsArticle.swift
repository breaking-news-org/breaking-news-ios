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

// MARK: - Article

struct NewsArticle: Equatable, Hashable, Identifiable {

	// MARK: Exposed properites

	let id: String

	let author: String

	let title: String

	let content: String

	let creationDate: Date

	let images: [Data]

	var enumeratedImages: [ImageData] {
		return images.enumerated().map({ ImageData(id: $0.offset, data: $0.element) })
	}

	struct ImageData: Identifiable {
		let id: Int
		let data: Data
	}

	// MARK: Init

	init(
		id: String,
		author: String,
		title: String,
		content: String,
		creationDate: Date,
		images: [Data]
	) {
		self.id = id
		self.author = author
		self.title = title
		self.content = content
		self.creationDate = creationDate
		self.images = images
	}

	init(from apiModel: NewsArticleResponse) {
		self.init(
			id: "\(apiModel.id)",
			author: apiModel.authorName,
			title: apiModel.title,
			content: apiModel.text,
			creationDate: apiModel.creationDate,
			images: apiModel.images
				.compactMap({ $0.data(using: .utf8) })
				.compactMap({ Data(base64Encoded: $0) })
		)
	}

}
