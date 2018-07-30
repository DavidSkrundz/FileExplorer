import Foundation
import UIKit

private let argc = CommandLine.argc
private let argv = UnsafeMutableRawPointer(CommandLine.unsafeArgv)
	.bindMemory(to: UnsafeMutablePointer<Int8>.self,
				capacity: Int(CommandLine.argc))
UIApplicationMain(argc, argv, nil, NSStringFromClass(AppDelegate.self))
