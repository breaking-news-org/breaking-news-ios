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
import Reachability

// MARK: - Service

final class NetworkService: NetworkServiceProtocol {

	// MARK: Exposed properties

	static let shared: NetworkService = try! NetworkService()

	// MARK: Private properties

	private let delegateQueue: DispatchQueue = DispatchQueue(
		label: "com.whutao.network-service.delegate-queue",
		qos: .utility
	)

	private let reachability: Reachability

	private var weakDelegates: [WeakDelegate] = []

	private var delegates: [NetworkServiceDelegate] {
		return weakDelegates.compactMap(\.delegate)
	}

	// MARK: Private types

	private final class WeakDelegate {

		weak var delegate: NetworkServiceDelegate?

		init(_ delegate: NetworkServiceDelegate? = nil) {
			self.delegate = delegate
		}

	}

	// MARK: Init/deinit

	private init() throws {
		self.reachability = try Reachability(notificationQueue: delegateQueue)

		reachability.whenReachable = { [weak self] _ in
			self?.delegates.forEach { $0.networkDidBecomeReachable() }
		}

		reachability.whenUnreachable = { [weak self] _ in
			self?.delegates.forEach { $0.networkDidBecomeUnreachable() }
		}

		try reachability.startNotifier()
	}

	deinit {
		reachability.stopNotifier()
	}

	// MARK: Exposed methods

	func addDelegate(_ delegate: NetworkServiceDelegate) {
		guard
			!weakDelegates.contains(where: { $0 === delegate })
		else {
			return
		}
		weakDelegates.append(WeakDelegate(delegate))
	}

	func removeDelegate(_ delegate: NetworkServiceDelegate) {
		weakDelegates.removeAll(where: { $0 === delegate })
	}

}
