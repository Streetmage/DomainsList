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

/// Type of the argument for `ArgumentsProvider`
typealias ArgumentType = RawRepresentable & Hashable

/// CLI arguments provider
struct ArgumentsProvider<T: ArgumentType> {
	// MARK: Private Properties
	private let arguments: [T: String]

	// MARK: Public Methods
	/// - parameters:
	///   - argumentsArray: array of CLI arguments
	init(_ argumentsArray: [String]) {
		var argumentsDictionary: [T: String] = [:]
		argumentsArray.enumerated().forEach { index, arg in
			guard let index = index as? T.RawValue, let argKey = T(rawValue: index) else { return }
			argumentsDictionary[argKey] = arg
		}
		self.arguments = argumentsDictionary
	}

	/// Get CLI argument value
	subscript(arg: T) -> String {
		guard let arg = arguments[arg], !arg.isEmpty else { fatalError(.argumentNotFound(arg)) }
		return arg
	}
}
