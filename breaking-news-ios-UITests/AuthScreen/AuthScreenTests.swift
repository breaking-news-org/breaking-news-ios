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

import XCTest
@testable import breaking_news_ios

// MARK: - Test class

final class AuthScreenUITests: XCTestCase {
	
	// MARK: Private properties
	
	private var app: XCUIApplication!
	
	private var authScreenProxy: AuthScreenProxy!
	
	private var newsScreenProxy: NewsScreenProxy!
	
	// MARK: Setup
	
	static override func setUp() {
		super.setUp()
		UIView.setAnimationsEnabled(false)
	}
	
	static override func tearDown() {
		UIView.setAnimationsEnabled(true)
		super.tearDown()
	}
	
	override func setUp() {
		super.setUp()
		
		app = XCUIApplication()
		app.launch()
		
		authScreenProxy = AuthScreenProxy(app: app)
		
		newsScreenProxy = NewsScreenProxy(app: app)
		newsScreenProxy.authButton.tap()
	}
	
	override func tearDown() {
		app = nil
		authScreenProxy = nil
		newsScreenProxy = nil
		super.tearDown()
	}
	
	// MARK: - Tests
	
	func testLoginFlow() {
		let validUsername = "1234567890"
		let validPassword = "1234567890"

		// Select the login tab
		authScreenProxy.loginTab.tap()
		
		// Fill out the login form
		
		authScreenProxy.usernameField.tap()
		authScreenProxy.usernameField.typeText(validUsername)
		
		authScreenProxy.passwordField.tap()
		authScreenProxy.passwordField.typeText(validPassword)
		
		// Tap the login button
		authScreenProxy.loginButton.tap()
	}
	
	func testRegisterFlow() {
		let validNickname = "1234567890"
		let validUsername = "1234567890"
		let validPassword = "1234567890"
		let validRepeatedPassword = "1234567890"
		
		authScreenProxy.registrationTab.tap()
		
		// Fill out the login form
		
		authScreenProxy.nicknameField.tap()
		authScreenProxy.nicknameField.typeText(validNickname)
		
		authScreenProxy.usernameField.tap()
		authScreenProxy.usernameField.typeText(validUsername)
		
		authScreenProxy.passwordField.tap()
		authScreenProxy.passwordField.typeText(validPassword)
		
		authScreenProxy.repeatPasswordField.tap()
		authScreenProxy.repeatPasswordField.typeText(validRepeatedPassword)
		
		// Tap the registration button
		authScreenProxy.registrationButton.tap()
	}
	
}
