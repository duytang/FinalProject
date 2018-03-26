//
//  Bundle.swift
//  Blank Project
//
//  Created by framgia on 5/31/17.
//  Copyright © 2017 Vo Nguyen Chi Phuong. All rights reserved.
//

import Foundation

let kCFBundleDisplayNameKey = "kCFBundleDisplayName"
let kCFBundleNameKey = "CFBundleName"
let kCFBundleShortVersionKey = "CFBundleShortVersionString"

extension Bundle {
    var name: String {
        guard let info = infoDictionary else { return "" }
        return info[kCFBundleDisplayNameKey] as? String ?? info[kCFBundleNameKey] as? String ?? ""
    }

    var version: String {
        guard let info = infoDictionary else { return "" }
        return info[kCFBundleVersionKey as String] as? String ?? ""
    }

    var build: String {
        guard let info = infoDictionary else { return "" }
        return info[kCFBundleShortVersionKey] as? String ?? ""
    }
}
