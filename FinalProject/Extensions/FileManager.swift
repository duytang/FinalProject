//
//  FileManger.swift
//  Blank Project
//
//  Created by framgia on 5/31/17.
//  Copyright © 2017 Vo Nguyen Chi Phuong. All rights reserved.
//

import Foundation

extension FileManager {
    class var homeDir: String! {
        return NSHomeDirectory()
    }

    class var homeUrl: NSURL! {
        return NSURL(fileURLWithPath: homeDir, isDirectory: true)
    }

    class var docDir: String! {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
    }

    class var docUrl: NSURL! {
        return NSURL(fileURLWithPath: docDir, isDirectory: true)
    }

    class var libraryDir: String! {
        return NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).first
    }

    class var libraryUrl: NSURL! {
        return NSURL(fileURLWithPath: libraryDir, isDirectory: true)
    }

    class var appSupportDir: String! {
        return NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true).first
    }

    class var appSupportUrl: NSURL! {
        return NSURL(fileURLWithPath: appSupportDir, isDirectory: true)
    }

    class var tmpDir: String {
        return NSTemporaryDirectory()
    }

    class var tmpUrl: NSURL {
        return NSURL(fileURLWithPath: tmpDir, isDirectory: true)
    }

    class func skipBackup(path: String) -> Bool {
        let fm = self.default
        var isDir: ObjCBool = true
        if fm.fileExists(atPath: path, isDirectory: &isDir) {
            if isDir.boolValue {
                var success = true
                do {
                    let urls = try fm.contentsOfDirectory(atPath: path)
                    for url in urls {
                        success = success && skipBackup(path: url)
                    }
                    return success
                } catch { }
            } else {
                do {
                    let url = NSURL(fileURLWithPath: path)
                    try url.setResourceValue(true, forKey: URLResourceKey.isExcludedFromBackupKey)
                    return true
                } catch { }
            }
        }
        return false
    }

    class func skipBackup() {
        let _ = skipBackup(path: docDir)
        let _ = skipBackup(path: libraryDir)
    }
}

