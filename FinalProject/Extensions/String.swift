//
//  StringExtension.swift
//  Blank Project
//
//  Created by framgia on 5/29/17.
//  Copyright © 2017 Vo Nguyen Chi Phuong. All rights reserved.
//

import Foundation

extension String {

    var length: Int {
        return self.count
    }

    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }

    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }

    subscript (r: Range<Int>) -> String {
        let start = index(startIndex, offsetBy: r.lowerBound)
        let end = index(startIndex, offsetBy: r.upperBound - r.lowerBound)
        return String(self[Range(start ..< end)])
    }

    func utf8String() -> String? {
        return self.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlHostAllowed)
    }

    var intValue: Int? {
        return Int(self)
    }

    var doubleValue: Double? {
        return Double(self)
    }

    var floatValue: Float? {
        return Float(self)
    }

    var boolValue: Bool {
        return (self as NSString).boolValue
    }

    func stringByAppendingPathComponent(str: String) -> String {
        return (self as NSString).appendingPathComponent(str)
    }

    var pathComponents: [String] {
        return (self as NSString).pathComponents
    }

    var lastPathComponent: String {
        return (self as NSString).lastPathComponent
    }

    var pathExtension: String {
        return (self as NSString).pathExtension
    }

    var url: NSURL? {
        return NSURL(string: self)
    }

    func validate(regex: String) -> Bool {
        let pre = NSPredicate(format: "SELF MATCHES %@", regex)
        return pre.evaluate(with: self)
    }

    // Regex
    func matches(pattern: String, ignoreCase: Bool = false) -> [NSTextCheckingResult]? {
        if let regex = NSRegularExpression.regex(pattern: pattern, ignoreCase: ignoreCase) {
            let range = NSRange(location: 0, length: length)
            return regex.matches(in: self, options: [], range: range).map { $0 }
        }
        return nil
    }

    func contains(pattern: String, ignoreCase: Bool = false) -> Bool? {
        if let regex = NSRegularExpression.regex(pattern: pattern, ignoreCase: ignoreCase) {
            let range = NSRange(location: 0, length: self.count)
            return regex.firstMatch(in: self, options: [], range: range) != nil
        }
        return nil
    }

    func replace(pattern: String, withString replacementString: String, ignoreCase: Bool = false) -> String? {
        if let regex = NSRegularExpression.regex(pattern: pattern, ignoreCase: ignoreCase) {
            let range = NSRange(location: 0, length: self.count)
            return regex.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: replacementString)
        }
        return nil
    }

    func insert(index: Int, _ string: String) -> String {
        if index > length {
            return self + string
        } else if index < 0 {
            return string + self
        }
        return self[0 ..< index] + string + self[index ..< length]
    }

    static func random(length len: Int = 0, charset: String = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789") -> String {
        let len = len < 1 ? len : Int.random(max: 16)
        var result = String()
        let max = charset.length - 1
        for _ in 0 ..< len {
            result += String(charset[Int.random(min: 0, max: max)])
        }
        return result
    }

    func localized() -> String {
        return NSLocalizedString(self, comment: "")
    }
}

extension String {

    func regex(pattern: String) -> Bool {
        let regexText = NSPredicate(format: "SELF MATCHES %@", pattern)
        return regexText.evaluate(with: self)
    }

    var isEmail: Bool {
        return regex(pattern: Regex.email)
    }
}
