//
//  FS.swift
//  FileExplorer
//

import Foundation

private let FSM = FileManager.default

class FS {
	static func contents(of directory: URL) throws -> [URL] {
		return try FSM.contentsOfDirectory(at: directory, includingPropertiesForKeys: nil, options: [])
	}
	
	static func isFolder(_ directory: URL) -> Bool {
		var bool: ObjCBool = false
		FSM.fileExists(atPath: directory.path, isDirectory: &bool)
		return bool.boolValue
	}
}
