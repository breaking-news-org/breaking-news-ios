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

struct NewsScreen: View {

	// MARK: Private properties

	@ObservedObject private var viewModel: NewsScreenViewModel

	@State private var isAuthScreenPresented: Bool = false

	@State private var isCreateScreenPresented: Bool = false

	@State private var selectedArticle: NewsArticle?

	// MARK: Init

	init(viewModel: NewsScreenViewModel) {
		self.viewModel = viewModel
	}

	// MARK: Body

	var body: some View {
		ZStack {
			Color.white
				.edgesIgnoringSafeArea(.all)

			VStack(alignment: .leading, spacing: Padding.s) {
				titleLabel()

				navigationBar()

				ZStack {
					if viewModel.isAuthorized {
						newsList()
					} else {
						stubView()
					}
				}
			}
		}
		.animation(.spring(), value: selectedArticle)
		.overlay {
			if let article = selectedArticle {
				ArticleScreen(
					article: article,
					didTapBack: {
						withAnimation {
							selectedArticle = nil
						}
					}
				)
				.transition(.move(edge: .bottom))
				.edgesIgnoringSafeArea(.bottom)
			}
		}
		.overlay {
			if isCreateScreenPresented {
				CreateScreen(
					viewModel: CreateScreenViewModel(createAction: {
						withAnimation {
							isCreateScreenPresented = false
						}
					}),
					didTapBack: {
						withAnimation {
							isCreateScreenPresented = false
						}
					}
				)
				.transition(.move(edge: .bottom))
				.edgesIgnoringSafeArea(.bottom)
			}
		}
		.sheet(isPresented: $isAuthScreenPresented) {
			AuthScreen(
				viewModel: AuthScreenViewModel(dismissAction: {
					withAnimation {
						isAuthScreenPresented = false
					}
				})
			)
		}
		.onFirstAppear {
			viewModel.updateNews()
		}
	}

	// MARK: Private properties

	// Components

	@ViewBuilder private func titleLabel() -> some View {
		Text("Breaking news!")
			.font(.h1Bold)
			.padding(.horizontal, 2 * Padding.xl)
			.padding(.top, Padding.xxxxl)
	}

	@ViewBuilder private func navigationBar() -> some View {
		HStack {
			Group {
				if let nickname = viewModel.nickname {
					Text("Welcome, \(nickname)")
				} else {
					Text("Welcome")
				}
			}
			.lineLimit(1)
			.font(.h2Medium)
			.foregroundColor(Asset.Colors.gunmetal.swiftUIColor)

			Spacer()

			logoutButton()
				.frame(size: .square(40))
		}
		.padding(.horizontal, 2 * Padding.xl)
	}

	@ViewBuilder private func stubView() -> some View {
		VStack(alignment: .center, spacing: Padding.l) {
			Spacer()

			HStack {
				Spacer()

				Text("Please, sign in into your account.")
					.font(.h3Medium)
					.foregroundColor(Asset.Colors.gunmetal.swiftUIColor)
					.multilineTextAlignment(.center)

				Spacer()
			}

			HStack {
				Spacer()

				Text("All news will be available here.")
					.font(.h4Medium)
					.foregroundColor(Asset.Colors.gunmetal.swiftUIColor)
					.multilineTextAlignment(.center)

				Spacer()
			}

			Spacer()
		}
		.padding(.horizontal, 2 * Padding.xl)
	}

	@ViewBuilder private func newsList() -> some View {
		ZStack(alignment: .bottomTrailing) {
			ScrollView {
				LazyVStack(alignment: .center, spacing: Padding.m) {
					ForEach(viewModel.news) { article in
						newsArticleEntryView(for: article)
							.padding(.horizontal, 2 * Padding.xl)
							.padding(.vertical, Padding.xxs)
							.contentShape(Rectangle())
							.onTapGesture {
								withAnimation {
									selectedArticle = article
								}
							}
					}
				}
				.padding(.top, Padding.xxxl)
				.padding(.bottom, 300)
			}
			.edgesIgnoringSafeArea(.bottom)
			.refreshable {
				viewModel.updateNews()
			}

			if viewModel.isAuthorized {
				CircleButton {
					withAnimation {
						isCreateScreenPresented = true
					}
				} label: {
					Image(systemName: "plus")
						.resizable()
						.foregroundColor(Asset.Colors.pantone.swiftUIColor)
						.padding(Padding.xxs)
				}
				.frame(size: .square(60))
				.offset(x: -2 * Padding.xxl, y: -6 * Padding.xxxl)
				.shadow(
					color: Asset.Colors.ashGray.swiftUIColor.opacity(0.5),
					radius: 6
				)
			}
		}
	}

	// Blocks

	@ViewBuilder private func logoutButton() -> some View {
		CircleButton {
			if viewModel.isAuthorized {
				viewModel.logout()
			} else {
				isAuthScreenPresented = true
			}
		} label: {
			Asset.Images.logout.swiftUIImage
				.resizable()
				.scaledToFit()
				.foregroundColor(Asset.Colors.battleshipGray.swiftUIColor)
				.padding(Padding.xxs)
		}
		.accessibilityIdentifier("Auth")
	}

	@ViewBuilder private func newsArticleEntryView(
		for article: NewsArticle
	) -> some View {
		HStack(alignment: .center, spacing: Padding.xxl) {
			Group {
				if let data = article.images.first {
					KFImage(imageData: data)
						.resizable()
						.scaledToFill()
				} else {
					Asset.Images.emptyImage.swiftUIImage
						.resizable()
						.scaledToFill()
				}
			}
			.frame(width: 120, height: 80)
			.clipShape(RoundedRectangle(cornerRadius: CornerRadius.m))
			.overlay {
				RoundedRectangle(cornerRadius: CornerRadius.m)
					.stroke(Asset.Colors.ashGray.swiftUIColor, lineWidth: 0.1)
			}

			VStack {
				Spacer()

				HStack {
					Text(article.title)

					Spacer()
				}
				.font(.h3Medium)
				.foregroundColor(Asset.Colors.gunmetal.swiftUIColor)

				Spacer()

				HStack {
					Asset.Images.calendar.swiftUIImage
						.resizable()
						.aspectRatio(contentMode: .fit)
						.frame(size: .square(16))

					Text(Formatters.dayAndMonthDateFormatter.string(from: article.creationDate))

					Spacer()

					Asset.Images.clock.swiftUIImage
						.resizable()
						.aspectRatio(contentMode: .fit)
						.frame(size: .square(16))

					Text(DateDifference(fromNowTo: article.creationDate).localisedString)
				}
				.font(.h5Regular)
				.foregroundColor(Asset.Colors.battleshipGray.swiftUIColor)

				Spacer()
			}
		}
	}

}

// MARK: - Previews

#if DEBUG
import Dependencies

struct NewsScreen_Previews: PreviewProvider {

	private static let viewModel = withDependencies { dependency in
		dependency.apiService = APIServiceDependency.previewValue
		dependency.userService = UserServiceDependency.previewValue
		dependency.newsService = NewsServiceDependencyKey.previewValue
	} operation: {
		NewsScreenViewModel()
	}

	static var previews: some View {
		NavigationView {
			NewsScreen(viewModel: viewModel)
		}
	}

}
#endif
