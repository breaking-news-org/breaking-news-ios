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

import SwiftUI
import Introspect
import Kingfisher

// MARK: - View

struct ArticleScreen: View {

	// MARK: Private properties

	@ObservedObject private var viewModel: ArticleScreenViewModel

	@State private var selectedImageIndex: Int = 0

	@State private var isPresentingShareView: Bool = false

	private let didTapBack: (() -> Void)?

	// MARK: Init

	init(
		viewModel: ArticleScreenViewModel,
		didTapBack: (() -> Void)? = nil
	) {
		self.viewModel = viewModel
		self.didTapBack = didTapBack
	}

	init(
		article: NewsArticle,
		didTapBack: (() -> Void)? = nil
	) {
		self.init(
			viewModel: ArticleScreenViewModel(article: article),
			didTapBack: didTapBack
		)
	}

	// MARK: Body

	var body: some View {
		ZStack {
			Asset.Colors.babyPowder.swiftUIColor
				.edgesIgnoringSafeArea(.all)

			VStack(alignment: .leading, spacing: Padding.xl) {
				navigationBar()
					.padding(.vertical, Padding.xxl)
					.padding(.horizontal, 2 * Padding.xl)

				ScrollView(showsIndicators: false) {
					VStack(spacing: 2 * Padding.xl) {
						headerView()
							.padding(.horizontal, 2 * Padding.xl)

						imagesView()

						textContentView()
							.padding(.horizontal, 2 * Padding.xxl)
					}
					.padding(.bottom, 300)
				}
			}
		}
		.sheet(isPresented: $isPresentingShareView) {
			ActivityView(
				activityItems: ["Breaking neeews!"],
				applicationActivities: nil
			)
		}
	}

	// MARK: Private properties

	// Components

	@ViewBuilder private func navigationBar() -> some View {
		HStack {
			backButton()
				.frame(size: .square(44))

			Spacer()

			Text(DateDifference(fromNowTo: viewModel.article.creationDate).localisedString)
				.font(.h4Regular)
				.foregroundColor(Asset.Colors.gunmetal.swiftUIColor)

			Spacer()

			shareButton()
				.frame(size: .square(44))
		}
	}

	@ViewBuilder private func headerView() -> some View {
		VStack(alignment: .center, spacing: Padding.s) {
			HStack {
				Spacer()

				Text(viewModel.article.title)
					.font(.h3Medium)
					.multilineTextAlignment(.center)

				Spacer()
			}

			HStack {
				Spacer()

				Text("by \(viewModel.article.author)")
					.lineLimit(nil)
					.font(.h5Regular)
					.multilineTextAlignment(.center)

				Spacer()
			}
		}
		.foregroundColor(Asset.Colors.gunmetal.swiftUIColor)
	}

	@ViewBuilder private func imagesView() -> some View {
		if !viewModel.article.images.isEmpty {
			GeometryReader { _ in
				TabView(selection: $selectedImageIndex) {
					ForEach(viewModel.article.enumeratedImages, id: \.id) { enumeratedImage in
						GeometryReader { _ in
							KFImage(imageData: enumeratedImage.data)
								.resizable()
								.aspectRatio(contentMode: .fill)
						}
					}
					.clipShape(RoundedRectangle(cornerRadius: CornerRadius.m))
					.clipped()
					.padding(.horizontal, 2 * Padding.xxl)
				}
				.tabViewStyle(.page(indexDisplayMode: .automatic))
			}
			.height(200)
		}
	}

	@ViewBuilder private func textContentView() -> some View {
		Text(viewModel.article.content)
			.font(.h5Regular)
			.foregroundColor(Asset.Colors.gunmetal.swiftUIColor)
			.multilineTextAlignment(.leading)
	}

	// Elements

	@ViewBuilder private func shareButton() -> some View {
		CircleButton {
			withAnimation {
				isPresentingShareView = true
			}
		} label: {
			Asset.Images.share.swiftUIImage
				.resizable()
				.scaledToFit()
				.foregroundColor(Asset.Colors.gunmetal.swiftUIColor)
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

}

// MARK: - Previews

#if DEBUG
import Dependencies

struct ArticleScreen_Previews: PreviewProvider {

	private static let viewModel = withDependencies { dependency in
		dependency.apiService = APIServiceDependency.previewValue
		dependency.userService = UserServiceDependency.previewValue
		dependency.newsService = NewsServiceDependencyKey.previewValue
	} operation: {
		ArticleScreenViewModel(article: .mocked())
	}

	static var previews: some View {
		NavigationView {
			ArticleScreen(viewModel: viewModel)
		}
	}

}
#endif
