//
//  Regex.swift
//  Blank Project
//
//  Created by framgia on 5/31/17.
//  Copyright © 2017 Vo Nguyen Chi Phuong. All rights reserved.
//

import Foundation

struct Regex {
    static let email = "^[^@]+@[^@]+$"

    static let hiragana = "[ぁ-ゔゞ゛゜ー]+"
    static let katakana = "[ァ-・ヽヾ゛゜ー]+"
    static let numberic = "[0-9]+"
    static let password = "[^\\s]+"
    static let symbol = "[:{}()\\[\\]+-.,!@#$%^&*();\\/<>$\\|\"'\\\\_£€$¥•?=~]+"
    static let organizationCode = "[\\d[A-Za-z-]]+"
    static let versionName = "[0-9]+(.[0-9])+.[0-9]"
}

extension NSRegularExpression {
    class func regex(pattern: String, ignoreCase: Bool = false) -> NSRegularExpression? {
        let options: NSRegularExpression.Options = ignoreCase ? [.caseInsensitive]: []
        var regex: NSRegularExpression?
        do {
            regex = try NSRegularExpression(pattern: pattern, options: options)
        } catch {
            regex = nil
        }
        return regex
    }
}
