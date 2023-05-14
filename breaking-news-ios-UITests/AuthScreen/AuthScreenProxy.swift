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

// MARK: - Proxy

final class AuthScreenProxy {
	
	// MARK: Private properties
	
	private let app: XCUIApplication
	
	// MARK: Init
	
	init(app: XCUIApplication) {
		self.app = app
	}
	
	// MARK: Exposed properties
	
	// Tabs
	var loginTab: XCUIElement { app.staticTexts["Log in"] }
	var registrationTab: XCUIElement { app.staticTexts["Register"] }
	
	// Text fields
	var nicknameField: XCUIElement { app.textFields["nickname"] }
	var usernameField: XCUIElement { app.textFields["username"] }
	var passwordField: XCUIElement { app.secureTextFields["password"] }
	var repeatPasswordField: XCUIElement { app.secureTextFields["repeatedPassword"] }
	
	// Buttons
	var loginButton: XCUIElement { app.buttons["Log in"] }
	var registrationButton: XCUIElement { app.buttons["Register"] }
	
	// Views
	var loginSuccessView: XCUIElement { app.staticTexts["Login Success"] }
	var registrationSuccessView: XCUIElement { app.staticTexts["Registration Success"] }
	
}
