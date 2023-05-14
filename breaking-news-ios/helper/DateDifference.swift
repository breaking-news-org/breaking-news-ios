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

// MARK: - Model

enum DateDifference {

	// MARK: Cases

	case lessThanMinute

	case minutes(Int)

	case hours(Int)

	case days(Int)

	case months(Int)

	case years(Int)

	// MARK: Exposed properties

	var localisedString: String {
		switch self {
		case .lessThanMinute:
			return "Just now"
		case let .minutes(int):
			return "\(int) minutes ago"
		case let .hours(int):
			return "\(int) hours ago"
		case let .days(int):
			return "\(int) days ago"
		case let .months(int):
			return "\(int) months ago"
		case let .years(int):
			return "\(int) years ago"
		}
	}

	// MARK: Init

	init(between date1: Date, and date2: Date) {
		var distance: TimeInterval = abs(date1.distance(to: date2))

		if distance < 60 {
			self = .lessThanMinute
			return
		} else {
			distance /= 60
		}

		if distance < 60 {
			self = .minutes(max(1, Int(distance)))
			return
		} else {
			distance /= 60
		}

		if distance < 24 {
			self = .hours(max(1, Int(distance)))
			return
		} else {
			distance /= 24
		}

		if distance < 30 {
			self = .months(max(1, Int(distance)))
			return
		} else {
			distance /= 365
		}

		self = .years(max(1, Int(distance)))
	}

	init(fromNowTo date: Date) {
		self.init(between: .now, and: date)
	}

}
