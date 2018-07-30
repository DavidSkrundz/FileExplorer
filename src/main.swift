//
//  main.swift
//  FileExplorer
//

import Foundation
import UIKit

private let FLAG_PLATFORMIZE: UInt32 = 1 << 1
typealias EntitleFunc = @convention(c) (pid_t, UInt32) -> Void
typealias SetUIDFunc = @convention(c) (pid_t) -> Void

private func platformize_me() {
	guard let handle = dlopen("/usr/lib/libjailbreak.dylib", RTLD_LAZY)
		else { return }
	guard let ptr = dlsym(handle, "jb_oneshot_entitle_now")
		else { return }
	let fix = unsafeBitCast(ptr, to: EntitleFunc.self)
	fix(getpid(), FLAG_PLATFORMIZE)
}

private func patch_setuid() {
	guard let handle = dlopen("/usr/lib/libjailbreak.dylib", RTLD_LAZY)
		else { return }
	guard let ptr = dlsym(handle, "jb_oneshot_fix_setuid_now")
		else { return }
	let fix = unsafeBitCast(ptr, to: SetUIDFunc.self)
	fix(getpid())
}

platformize_me()
patch_setuid()
if !(setuid(0) == 0 && setgid(0) == 0) { exit(EXIT_FAILURE) }

private let argc = CommandLine.argc
private let argv = UnsafeMutableRawPointer(CommandLine.unsafeArgv)
	.bindMemory(to: UnsafeMutablePointer<Int8>.self,
				capacity: Int(CommandLine.argc))
UIApplicationMain(argc, argv, nil, NSStringFromClass(AppDelegate.self))
