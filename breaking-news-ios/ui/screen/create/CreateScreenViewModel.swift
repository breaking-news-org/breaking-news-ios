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

import Dependencies
import SwiftUI
import PhotosUI

// MARK: - View-model

final class CreateScreenViewModel: ObservableObject {

	// MARK: Exposed properties
	
	let maxPhotoCount: Int = 6

	@MainActor @Published var title: String = ""

	@MainActor @Published var content: String = ""

	@MainActor @Published var isLoading: Bool = false

	@MainActor @Published var isCreated: Bool = false
	
	@MainActor @Published var photosData: [Data] = []

	@MainActor var isFormCorrect: Bool {
		return !title.isEmpty && !content.isEmpty
	}
	
	// MARK: Exposed types

	// MARK: Private properties

	@Dependency(\.newsService) private var newsService: NewsServiceProtocol

	private let createAction: (() -> Void)?

	// MARK: Init

	init(createAction: (() -> Void)? = nil) {
		self.createAction = createAction
	}

	// MARK: Exposed methods

	@MainActor func create() {
		guard
			!isLoading
		else {
			return
		}

		isLoading = true

		let title = title
		let content = content

		Task {
			do {
				try await newsService.createArticle(
					title: title,
					text: content,
					imagesData: photosData
				)
				await MainActor.run {
					NotificationCenter.default.post(name: .refreshNews, object: nil)
					createAction?()
				}
			} catch let error {
				log.error(error)
			}

			await MainActor.run {
				isLoading = false
			}
		}
	}

}
