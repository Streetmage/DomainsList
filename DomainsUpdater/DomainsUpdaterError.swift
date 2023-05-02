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

/// Error type for domains updater
enum DomainsUpdaterError: LocalizedError {
	case unrecognizedCommand
	case argumentNotFound(any RawRepresentable)
	case remotePathIsInvalid
	case failedToLoadRemoteFile(Error)
	case localDomainsFileNotSaved(Error)
	case infoPlistNotFound
	case infoPlistNotSaved(Error)

	var errorDescription: String? {
		switch self {
		case .unrecognizedCommand:
			return "Unrecognized command, use either: \(Command.allCases)"
		case .argumentNotFound(let argument):
			return "\(argument) not found at index \(argument.rawValue)"
		case .remotePathIsInvalid:
			return "Remote path is invalid URL"
		case .failedToLoadRemoteFile(let error):
			return "Failed to load remote file: \(error)"
		case .localDomainsFileNotSaved(let error):
			return "Error saving local domains file: \(error)"
		case .infoPlistNotFound:
			return "info.plist not found"
		case .infoPlistNotSaved(let error):
			return "Error saving info.plist: \(error)"
		}

	}
}

/// Custom fatal error overload for `DomainsUpdaterError`
func fatalError(_ error: DomainsUpdaterError) -> Never {
	fatalError(error.localizedDescription)
}
