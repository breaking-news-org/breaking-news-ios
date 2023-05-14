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

#if DEBUG
import UIKit

extension NewsArticle {

	private static let previewImages: [UIImage] = [
		Asset.Images.mockDeer.image,
		Asset.Images.mockTree.image,
		Asset.Images.mockStars.image,
		Asset.Images.mockTrees.image
	]

	static func mocked(numberOfImages: Int? = nil) -> NewsArticle {
		let imageCount: Int = {
			if let numberOfImages {
				return numberOfImages
			} else {
				return .random(in: 0...previewImages.count)
			}
		}()

		let images = Range(0...imageCount)
			.compactMap({ _ in previewImages.randomElement() })
			.compactMap({ $0.jpegData(compressionQuality: 1.0) })

		return NewsArticle(
			id: UUID().uuidString.lowercased(),
			author: Lorem.fullname,
			title: Lorem.shortSentence,
			content: [
				Lorem.shortParagraph,
				Lorem.shortParagraph,
				Lorem.shortParagraph,
				Lorem.shortParagraph,
				Lorem.shortParagraph,
				Lorem.shortParagraph,
				Lorem.shortParagraph
			].joined(separator: "\n\n"),
			creationDate: Date().advanced(by: -1 * .random(in: 0...50_000)),
			images: images.compactMap({ $0 })
		)
	}

}
#endif
