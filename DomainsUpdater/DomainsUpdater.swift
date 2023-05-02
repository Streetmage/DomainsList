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

@main
enum DomainsUpdater {
	// MARK: - Types
	private enum Constants {
		static let domainsTabsOffset = "\n\t\t"
		static let domainsOpenTag = "\(domainsTabsOffset)<dict>"
		static let domainsCloseTag = "\(domainsTabsOffset)</dict>"
		static let domainsPattern = "(?<=<key>NSExceptionDomains</key>)[\\s\\S]*?\(domainsTabsOffset)(</dict>|<dict/>)"
		static let domainItemFormat = "\(domainsTabsOffset)\t<key>%@</key><dict><key>NSExceptionAllowsInsecureHTTPLoads</key><%@/></dict>"
	}

	// MARK: - Public Methods
	static func main() {
		let args = ArgumentsProvider<CommandArgument>(ProcessInfo.processInfo.arguments)
		guard let command = Command(rawValue: args[.command]) else { fatalError(.unrecognizedCommand) }

		switch command {
		case .update:
			update()
		case .clean:
			clean()
		}
	}
}

// MARK: - Private Methods
private extension DomainsUpdater {
	// MARK: Commands
	static func update() {
		let args = ArgumentsProvider<UpdateArgument>(ProcessInfo.processInfo.arguments)
		let domains = fetchDomainsJson(remotePath: args[.remotePath])
		updateLocalFile(at: args[.localPath], domains: domains)
		updateInfoPlist(at: args[.infoPlistPath], domains: domains)
	}

	static func clean() {
		let args = ArgumentsProvider<CleanArgument>(ProcessInfo.processInfo.arguments)
		updateLocalFile(at: args[.localPath], domains: [])
		updateInfoPlist(at: args[.infoPlistPath], domains: [])
	}

	// MARK: Working with JSON file
	static func fetchDomainsJson(remotePath: String) -> [Domain] {
		guard let url = URL(string: remotePath) else { fatalError(.remotePathIsInvalid) }
		do {
			let data = try Data(contentsOf: url)
			return try JSONDecoder().decode([Domain].self, from: data)
		} catch {
			fatalError(.failedToLoadRemoteFile(error))
		}
	}

	static func updateLocalFile(at path: String, domains: [Domain]) {
		let url = URL(fileURLWithPath: path)
		do {
			let data = try JSONEncoder().encode(domains)
			try data.write(to: url)
		} catch {
			fatalError(.localDomainsFileNotSaved(error))
		}
	}

	// MARK: Working with Info.plist
	static func updateInfoPlist(at path: String, domains: [Domain]) {
		let url = URL(fileURLWithPath: path)
		guard let data = try? Data(contentsOf: url),
			  let infoPlist = String(data: data, encoding: .utf8)
		else { fatalError(.infoPlistNotFound) }

		let updatedInfoPlist = replaceInfoPlistDomains(infoPlist, domains: domains)

		do {
			try updatedInfoPlist.write(
				to: url,
				atomically: true,
				encoding: .utf8
			)
		} catch {
			fatalError(.infoPlistNotSaved(error))
		}
	}

	static func replaceInfoPlistDomains(_ infoPlist: String, domains: [Domain]) -> String {
		var updatedDomains = Constants.domainsOpenTag
		domains.forEach { domain in
			updatedDomains.append(
				String(
					format: Constants.domainItemFormat,
					domain.name,
					String(domain.allowsInsecureHTTPLoads)
				)
			)
		}
		updatedDomains.append(Constants.domainsCloseTag)
		let updatedInfoPlist = infoPlist.replacingOccurrences(
			of: Constants.domainsPattern,
			with: updatedDomains,
			options: .regularExpression
		)
		return updatedInfoPlist
	}
}
