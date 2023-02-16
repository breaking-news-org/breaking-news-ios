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
import GoogleSignIn

// MARK: - Model

/// Domain model for a google user.
struct GoogleUser {

	// MARK: Exposed properties

	/// Google client ID.
	let idToken: String

	/// User email.
	let email: String

	/// User avatar URL.
	let avatarUrl: URL?

	// MARK: Init

	/// Creates an instance from the Google raw model.
	init?(from rawModel: GIDGoogleUser) {
		guard
			let profile = rawModel.profile,
			let idToken = rawModel.idToken?.tokenString
		else {
			return nil
		}
		self.idToken = idToken
		self.avatarUrl = profile.imageURL(withDimension: 256)
		self.email = profile.email
	}

}
