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

import UIKit
import SwiftUI
import Introspect
import Kingfisher
import PhotosUI

// MARK: - View

struct CreateScreen: View {

	// MARK: Private properties

	@ObservedObject private var viewModel: CreateScreenViewModel
	
	@State private var selectedPhotoItems: [PhotosPickerItem] = []

	private let didTapBack: (() -> Void)?

	// MARK: Init

	init(
		viewModel: CreateScreenViewModel,
		didTapBack: (() -> Void)? = nil
	) {
		self.viewModel = viewModel
		self.didTapBack = didTapBack
	}

	// MARK: Body

	var body: some View {
		ZStack {
			Asset.Colors.babyPowder.swiftUIColor

			VStack(alignment: .center, spacing: Padding.xl) {
				navigationBar()
					.padding(.horizontal, 2 * Padding.xl)
					.padding(.bottom, Padding.xxl)

				ScrollView(showsIndicators: false) {
					VStack(alignment: .leading, spacing: Padding.xxxl) {
						Group {
							inputPhotoView()
							
							inputTextField(
								title: "Title",
								text: $viewModel.title
							)

							inputTextView(
								title: "Content",
								text: $viewModel.content
							)

							actionButton(
								title: "Create",
								isLoading: viewModel.isLoading,
								action: {
									viewModel.create()
								}
							)
						}
						.padding(.horizontal, 2 * Padding.xl)
					}
				}
			}
		}
		.disabled(viewModel.isLoading)
	}

	// MARK: Private properties

	// Elements

	@ViewBuilder private func navigationBar() -> some View {
		HStack {
			backButton()
				.frame(size: .square(44))

			Spacer()

			Text("New article")
				.font(.h3Medium)
				.foregroundColor(Asset.Colors.gunmetal.swiftUIColor)

			Spacer()

			Spacer()
				.frame(size: .square(44))
		}
	}
	
	@ViewBuilder private func backButton() -> some View {
		CircleButton {
			withAnimation {
				didTapBack?()
			}
		} label: {
			Asset.Images.backArrow.swiftUIImage
				.resizable()
				.scaledToFit()
				.foregroundColor(Asset.Colors.gunmetal.swiftUIColor)
		}
	}
	
	@ViewBuilder private func photoPickerButton() -> some View {
		PhotosPicker(
			selection: $selectedPhotoItems,
			maxSelectionCount: viewModel.maxPhotoCount,
			matching: .any(of: [.images, .screenshots, .panoramas])
		) {
			GeometryReader { geometry in
				ZStack {
					Asset.Colors.pantone.swiftUIColor
					
					Image(systemName: "plus")
						.resizable()
						.aspectRatio(contentMode: .fit)
						.foregroundColor(Asset.Colors.babyPowder.swiftUIColor)
						.frame(
							width: (0.5) * geometry.size.width,
							height: (0.5) * geometry.size.height
						)
				}
			}
			.clipShape(RoundedRectangle(cornerRadius: CornerRadius.m))
		}
		.onChange(of: selectedPhotoItems) { newSelectedPhotoItems in
			Task {
				let loadedImagesData: [Data?] = try await withThrowingTaskGroup(
					of: Optional<Data>.self
				) { group in
					newSelectedPhotoItems.forEach { item in
						group.addTask {
							guard
								let loadedData = try await item.loadTransferable(type: Data.self),
								let loadedImage = UIImage(data: loadedData),
								let jpegData = loadedImage.jpegData(compressionQuality: 0.2)
							else {
								return nil
							}
							return jpegData
						}
					}
					return try await group.reduce(into: [], { partialResult, data in partialResult.append(data) })
				}
				
				await MainActor.run {
					viewModel.photosData = loadedImagesData.compactMap({ $0 })
				}
			}
		}
	}
	
	@ViewBuilder private func inputPhotoView() -> some View {
		VStack(alignment: .leading, spacing: Padding.m) {
			Text("Images (\(viewModel.photosData.count)/\(viewModel.maxPhotoCount))")
				.font(.h6Regular)
				.foregroundColor(Asset.Colors.battleshipGray.swiftUIColor)
			
			FlexStack(verticalSpacing: Padding.m, horzontalSpacing: Padding.m) {
				ForEach(Array(viewModel.photosData.enumerated()), id: \.element) { index, data in
					ZStack(alignment: .topTrailing) {
						KFImage(imageData: data)
							.resizable()
							.scaledToFill()
							.frame(size: .square(100))
							.cornerRadius(CornerRadius.m)
							.clipped()
						
						Button {
							viewModel.photosData.remove(at: index)
						} label: {
							Image(systemName: "plus")
								.resizable()
								.aspectRatio(contentMode: .fit)
								.foregroundColor(Asset.Colors.babyPowder.swiftUIColor)
								.frame(size: .square(16))
								.padding(Padding.s)
								.background(Asset.Colors.battleshipGray.swiftUIColor)
								.clipShape(Capsule())
						}
						.scaleOnPress()
						.rotationEffect(.degrees(45), anchor: .center)
						.offset(x: 5, y: -5)
					}
				}
				
				if viewModel.photosData.count < viewModel.maxPhotoCount {
					photoPickerButton()
						.frame(size: .square(40))
				}
			}
		}
	}

	@ViewBuilder private func inputTextField(
		title: String,
		text: Binding<String>
	) -> some View {
		TextField("Example title...", text: text)
			.font(.h5Regular)
			.tint(Asset.Colors.gunmetal.swiftUIColor)
			.foregroundColor(Asset.Colors.gunmetal.swiftUIColor)
			.padding(.horizontal, Padding.s)
			.padding(.vertical, Padding.xs)
			.formFieldStyle(title: title)
	}

	@ViewBuilder private func inputTextView(
		title: String,
		text: Binding<String>
	) -> some View {
		TextField("Example content...", text: text, axis: .vertical)
			.lineLimit(5...100)
			.font(.h5Regular)
			.tint(Asset.Colors.gunmetal.swiftUIColor)
			.foregroundColor(Asset.Colors.gunmetal.swiftUIColor)
			.padding(.horizontal, Padding.s)
			.padding(.vertical, Padding.xs)
			.formFieldStyle(title: title)
	}

	@ViewBuilder private func actionButton(
		title: String,
		isLoading: Bool,
		action: (() -> Void)? = nil
	) -> some View {
		Button {
			action?()
		} label: {
			HStack {
				Spacer()

				Group {
					if isLoading {
						ProgressView()
							.tint(Asset.Colors.babyPowder.swiftUIColor)
					} else {
						Text(title)
							.font(.h3Medium)
							.foregroundColor(Asset.Colors.babyPowder.swiftUIColor)
							.contentTransition(.identity)
					}
				}
				.height(26)

				Spacer()
			}
			.foregroundColor(Asset.Colors.babyPowder.swiftUIColor)
			.frame(maxHeight: .infinity)
			.background(Asset.Colors.pantone.swiftUIColor)
			.cornerRadius(CornerRadius.m)
		}
		.scaleOnPress()
		.height(46)
		.disabled(isLoading)
	}

}

// MARK: - View extensions

extension View {

	@ViewBuilder fileprivate func formFieldStyle(
		title: String
	) -> some View {
		VStack(alignment: .leading, spacing: Padding.m) {
			Text(title)
				.font(.h6Regular)
				.foregroundColor(Asset.Colors.battleshipGray.swiftUIColor)

			self.padding(.vertical, Padding.s)
				.padding(.horizontal, Padding.s)
				.background(Color.white)
				.cornerRadius(CornerRadius.m)
				.overlay {
					RoundedRectangle(cornerRadius: CornerRadius.m)
						.stroke(Asset.Colors.battleshipGray.swiftUIColor, lineWidth: 0.3)
				}
		}
	}

}

// MARK: - Previews

#if DEBUG
import Dependencies

struct CreateScreen_Previews: PreviewProvider {

	private static let viewModel = withDependencies { dependency in
		dependency.apiService = APIServiceDependency.previewValue
		dependency.userService = UserServiceDependency.previewValue
		dependency.newsService = NewsServiceDependencyKey.previewValue
	} operation: {
		CreateScreenViewModel()
	}

	static var previews: some View {
		NavigationView {
			CreateScreen(viewModel: viewModel)
		}
	}

}
#endif
