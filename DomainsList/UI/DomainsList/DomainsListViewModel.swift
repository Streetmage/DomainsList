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

import SwiftUI

/// Domains list screen view model
@MainActor
final class DomainsListViewModel: ObservableObject {
	// MARK: - Types
	/// Screen state
	enum State {
		/// Start state
		case idle(String)
		/// Domains list is empty
		case empty(String)
		/// Domains list loaded
		case loaded([Domain])
		/// Loading error
		case error(String)
	}

	// MARK: - Public properties
	/// Sceen state
	@Published
	var state: State = .idle(Localizable.DomainsList.loading)

	// MARK: - Private properties
	private let domainsLoader: DomainsLoading

	// MARK: - Public Methods
	/// - parameters:
	///   - domainsLoader: domains list loader
	init(domainsLoader: DomainsLoading) {
		self.domainsLoader = domainsLoader
	}

	/// Метод перезагрузки данных
	func reload() async {
		do {
			let domains = try await domainsLoader.load()
			if domains.isEmpty {
				state = .empty(Localizable.DomainsList.empty)
			} else {
				state = .loaded(domains)
			}
		} catch {
			state = .error(Localizable.Error.errorFormat(error.localizedDescription))
		}
	}
}
