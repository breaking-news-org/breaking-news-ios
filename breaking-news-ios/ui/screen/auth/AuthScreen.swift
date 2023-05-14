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
import AlertToast

// MARK: - View

struct AuthScreen: View {

	// MARK: Private properties

	@ObservedObject private var viewModel: AuthScreenViewModel

	@FocusState private var focusedField: AuthField?

	@State private var isPasswordRevealed: Bool = false

	@State private var isRepreatedPasswordRevealed: Bool = false

	// MARK: Init

	init(viewModel: AuthScreenViewModel) {
		self.viewModel = viewModel
	}

	// MARK: Body

	var body: some View {
		ZStack {
			Color.white
				.edgesIgnoringSafeArea(.all)

			GeometryReader { geometry in
				ScrollView(.vertical) {
					VStack(alignment: .center, spacing: Padding.xxl) {
						VStack(alignment: .center, spacing: Padding.s) {
							titleLabel()
							subtitleLabel()
						}
						.padding(.bottom, Padding.xxxxl)

						screenModeSwitchView()
							.height(36)

						authorizationForm()
							.padding(.vertical, Padding.xxl)

						actionButton(
							title: viewModel.screenMode.actionTitle,
							isLoading: viewModel.isLoading,
							action: {
								switch viewModel.screenMode {
								case .login:
									viewModel.logIn()
								case .register:
									viewModel.register()
								}
							}
						)
						.accessibilityIdentifier({
							switch viewModel.screenMode {
							case .login:
								return "Log in"
							case .register:
								return "Register"
							}
						}())
					}
					.padding(.horizontal, 36)
					.frame(width: geometry.size.width)
					.frame(minHeight: geometry.size.height)
				}
				.scrollIndicators(.never)
			}
		}
		.disabled(viewModel.isLoading)
		.onChange(of: viewModel.screenMode) { _ in
			// Conceal passwords on any mode changes
			isPasswordRevealed = false
			isRepreatedPasswordRevealed = false
			// Reset repeated password on any mode changes
			viewModel.repeatedPassword = ""
		}
		.toast(
			isPresenting: $viewModel.shouldShowUserNotFoundToast,
			duration: 4.0,
			tapToDismiss: true,
			offsetY: Padding.xxxl
		) {
			AlertToast(
				displayMode: .hud,
				type: .regular,
				title: "User is not found. Please, create new account."
			)
		} onTap: {

		} completion: {

		}

	}

	// MARK: Private properties

	// Components

	@ViewBuilder private func titleLabel() -> some View {
		Text("Breaking news!")
			.lineLimit(1)
			.font(.h1Bold)
			.foregroundColor(Asset.Colors.gunmetal.swiftUIColor)
	}

	@ViewBuilder private func subtitleLabel() -> some View {
		Text(viewModel.screenMode == .login ? "Log in into existing account" : "Create new account")
			.lineLimit(1)
			.font(.h3Regular)
			.foregroundColor(.gray)
			.contentTransition(.identity)
	}

	@ViewBuilder private func screenModeSwitchView() -> some View {
		SegmentedControlView(
			segments: viewModel.screenModes,
			selectedSegment: $viewModel.screenMode,
			segmentContent: { mode in
				Text(mode.modeTitle)
					.accessibilityIdentifier({
						switch mode {
						case .login:
							return "Log in"
						case .register:
							return "Register"
						}
					}())
					.font(mode == viewModel.screenMode ? .h4Bold : .h4Medium)
					.foregroundColor(
						mode == viewModel.screenMode ?
						Asset.Colors.gunmetal.swiftUIColor :
						Asset.Colors.battleshipGray.swiftUIColor
					)
			},
			segmentBackgoundShape: {
				RoundedRectangle(cornerRadius: CornerRadius.m)
			},
			animation: .easeInOut,
			backgoundColor: Asset.Colors.battleshipGray.swiftUIColor.opacity(0.6),
			selectedSegmentBackgoundColor: Asset.Colors.babyPowder.swiftUIColor
		)
	}

	@ViewBuilder private func authorizationForm() -> some View {
		VStack(alignment: .center, spacing: Padding.xl) {
			if viewModel.screenMode == .register {
				textField(
					element: AuthField.nickname,
					text: $viewModel.nickname
				)
				.textContentType(.name)
				.formFieldStyle(element: AuthField.nickname)
				.contentShape(Rectangle())
				.onTapGesture {
					if focusedField != AuthField.nickname {
						focusedField = AuthField.nickname
					}
				}
				.transition(
					.asymmetric(
						insertion: .move(edge: .top).combined(with: .opacity),
						removal: .move(edge: .bottom).combined(with: .opacity)
					)
					.animation(.easeInOut)
				)
			}

			textField(
				element: AuthField.username,
				text: $viewModel.username
			)
			.textContentType(.nickname)
			.formFieldStyle(element: AuthField.username)
			.contentShape(Rectangle())
			.onTapGesture {
				focusedField = AuthField.username
			}

			passwordTextField(
				element: AuthField.password,
				text: $viewModel.password,
				isPasswordRevealed: $isPasswordRevealed
			)
			.textContentType(.password)
			.formFieldStyle(element: AuthField.password)
			.contentShape(Rectangle())
			.onTapGesture {
				focusedField = AuthField.password
			}

			if viewModel.screenMode == .register {
				passwordTextField(
					element: AuthField.repeatedPassword,
					text: $viewModel.repeatedPassword,
					isPasswordRevealed: $isRepreatedPasswordRevealed
				)
				.textContentType(.password)
				.formFieldStyle(element: AuthField.repeatedPassword)
				.contentShape(Rectangle())
				.onTapGesture {
					focusedField = AuthField.repeatedPassword
				}
				.transition(
					.asymmetric(
						insertion: .move(edge: .bottom).combined(with: .opacity),
						removal: .move(edge: .top).combined(with: .opacity)
					)
					.animation(.easeInOut)
				)
			}
		}
	}

	// Subcomponents

	@ViewBuilder private func textField(
		element: AuthField,
		text: Binding<String>,
		isSecure: Binding<Bool> = .constant(false)
	) -> some View {
		Group {
			if isSecure.wrappedValue {
				SecureField(element.fieldPlaceholder, text: text)
					.accessibilityIdentifier({
						switch element {
						case .username:
							return "username"
						case .nickname:
							return "nickname"
						case .password:
							return "password"
						case .repeatedPassword:
							return "repeatedPassword"
						}
					}())
			} else {
				TextField(element.fieldPlaceholder, text: text)
					.accessibilityIdentifier({
						switch element {
						case .username:
							return "username"
						case .nickname:
							return "nickname"
						case .password:
							return "password"
						case .repeatedPassword:
							return "repeatedPassword"
						}
					}())
			}
		}
		.textCase(.lowercase)
		.autocorrectionDisabled(true)
		.focused($focusedField, equals: element)
		.font(.h4Medium)
		.tint(Asset.Colors.battleshipGray.swiftUIColor)
		.foregroundColor(Asset.Colors.gunmetal.swiftUIColor)
		.height(16)
	}

	@ViewBuilder private func passwordTextField(
		element: AuthField,
		text: Binding<String>,
		isPasswordRevealed: Binding<Bool>
	) -> some View {
		HStack(alignment: .center, spacing: Padding.l) {
			textField(
				element: element,
				text: text,
				isSecure: Binding(
					get: { !isPasswordRevealed.wrappedValue },
					set: { isPasswordRevealed.wrappedValue = !$0 }
				)
			)

			Button {
				isPasswordRevealed.wrappedValue.toggle()
			} label: {
				Group {
					if isPasswordRevealed.wrappedValue {
						Image(systemName: "eye.slash")
					} else {
						Image(systemName: "eye")
					}
				}
				.foregroundColor(Asset.Colors.battleshipGray.swiftUIColor)
			}
			.scaleOnPress()
			.frame(size: .square(14))
		}
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
		.disabledAndFaintIf(viewModel.screenMode == .login && !viewModel.isLoginFormValid)
		.disabledAndFaintIf(viewModel.screenMode == .register && !viewModel.isRegisterFormValid)
	}

}

// MARK: - View extensions

extension View {

	@ViewBuilder fileprivate func formFieldStyle(
		element: AuthField
	) -> some View {
		VStack(alignment: .leading, spacing: Padding.xs) {
			Text(element.fieldTitle)
				.font(.h6Regular)
				.foregroundColor(Asset.Colors.battleshipGray.swiftUIColor)

			self.padding(.vertical, Padding.xl)
				.padding(.horizontal, Padding.xxl)
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

struct AuthScreen_Previews: PreviewProvider {

	static var previews: some View {
		AuthScreen(
			viewModel: withDependencies { dependency in
				dependency.apiService = APIServiceDependency.previewValue
				dependency.userService = UserServiceDependency.previewValue
			} operation: {
				AuthScreenViewModel()
			}
		)
	}

}
#endif
