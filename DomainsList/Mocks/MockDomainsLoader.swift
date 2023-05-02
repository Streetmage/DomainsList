// The MIT License (MIT)
//
// Copyright (c) 2023 Evgeny Kubrakov
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Foundation

/// Domains loader mock
final class MockDomainsLoader: DomainsLoading {
	// MARK: - Types
	/// Possible result
	enum Result {
		/// Empty result
		case empty
		/// Domains list
		case list
		/// Error
		case error
	}

	// MARK: - Private Methods
	private let result: Result

	// MARK: - Public Methods
	/// - parameters:
	///   - result: expected result
	init(result: Result) {
		self.result = result
	}

	// MARK: - DomainsLoading
	func load() async throws -> [Domain] {
		switch result {
		case .empty:
			return []
		case .list:
			return [
				Domain(
					name: "dev.app_main.com",
					description: "DEV environment for app testing",
					allowsInsecureHTTPLoads: true
				),
				Domain(
					name: "dev.app_quicksearch.com",
					description: "DEV environment for quick search testing",
					allowsInsecureHTTPLoads: true
				)
			]
		case .error:
			throw MockError()
		}
	}
}
