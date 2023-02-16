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
import RealmSwift

// MARK: - Database

final class Database: DatabaseProtocol {

	// MARK: Private properties

	private let schemaVersion: UInt64 = 1

	private let realmConfiguration: Realm.Configuration

	// MARK: Init/deinit

	init() {
		self.realmConfiguration = .defaultConfiguration
	}

	// MARK: Utils

	func databaseFileSize() -> UInt64? {
		guard
			let path = realmConfiguration.fileURL?.relativePath,
			let attributes = try? FileManager.default.attributesOfItem(atPath: path),
			let fileSize = attributes[FileAttributeKey.size] as? UInt64
		else {
			return nil
		}
		return fileSize
	}

	// MARK: Realm instance

	func realmInstance() throws -> Realm {
		return try Realm(configuration: realmConfiguration)
	}

	func unsafeRealmInstance() -> Realm {
		return try! realmInstance()
	}

	// MARK: Interface

	func objects<StoredObject: Object>(
		of type: StoredObject.Type
	) throws -> Results<StoredObject> {
		return try realmInstance().objects(StoredObject.self)
	}

	func writeOrUpdate<StoredObject: Object>(
		object: StoredObject
	) throws {

	}

}
