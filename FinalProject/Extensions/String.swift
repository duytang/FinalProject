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

    func regex(pattern: String) -> Bool {
        let regexText = NSPredicate(format: "SELF MATCHES %@", pattern)
        return regexText.evaluate(with: self)
    }

    var isEmail: Bool {
        return regex(pattern: Regex.email)
    }

    // MARK: - Get time of video
    func convertDuration() -> String {
        var duration = ""
        if checkDurationVideo(text: self) {
            guard let formattedDuration = self.replace(pattern: "PT", withString: "") else { return "-:-" }
            guard let hour = formattedDuration.replace(pattern: "H", withString: ":") else { return "-:-" }
            guard let minute = hour.replace(pattern: "M", withString: ":") else { return "-:-" }
            guard let second = minute.replace(pattern: "S", withString: "") else { return "-:-" }
            let components = second.components(separatedBy: ":")
            for component in components {
                duration = !duration.isEmpty ? duration + ":": duration
                if component.count < 2 {
                    duration += "0" + component
                    continue
                }
                duration += component
            }
        } else {
            duration = "-:-"
        }
        return duration
    }

    // MARK: - Validate time of Video
    func checkDurationVideo(text: String) -> Bool {
        let DURATION_REGEX_FULL = "^PT+[0-9]+H[0-9]+M[0-9]+S"
        let DURATION_REGEX = "^PT+[0-9]+M[0-9]+S"
        let durationTestFull = NSPredicate(format: "SELF MATCHES %@", DURATION_REGEX_FULL)
        let durationTest = NSPredicate(format: "SELF MATCHES %@", DURATION_REGEX)
        let test_REGEX_FULL = durationTestFull.evaluate(with: text)
        let test_REGEX = durationTest.evaluate(with: text)
        if test_REGEX_FULL || test_REGEX {
            return true
        } else {
            return false
        }
    }

    // MARK: - Get time upload of video
    func convertTimeUpload() -> String {
        let date = toDate(format: DateFormat.TZDateTime3, localized: false)
        let setComponent: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute, .second]
        let diffDateComponent = Calendar.current.dateComponents(setComponent, from: date, to: Date())
        if let year = diffDateComponent.year, year > 0 {
            return year > 1 ? "\(year) years ago" : "\(year) year ago"
        } else  if let month = diffDateComponent.month, month > 0 {
            return month > 1 ? "\(month) months ago" : "\(month) month ago"
        } else if let day = diffDateComponent.day, day > 0 {
            return day > 1 ? "\(day) days ago" : "\(day) day ago"
        } else if let hour = diffDateComponent.hour, hour > 0 {
            return hour > 1 ? "\(hour) hours ago" : "\(hour) hour ago"
        } else if let minute = diffDateComponent.minute, minute > 0 {
            return minute > 1 ? "\(minute) minutes ago" : "\(minute) minute ago"
        } else if let second = diffDateComponent.second, second > 0 {
            return second > 1 ? "\(second) seconds ago" : "just now"
        } else {
            return ""
        }
    }

    // MARK: - Show view count of video
    func getNumberView() -> String {
        var numberView = ""
        if isEmpty {
            numberView = "0 view"
        } else {
            guard let countView = Int(self) else { return "0 view" }
            if countView > 1 {
                if countView > 999_999 {
                    numberView = String(countView / 1_000_000) + "M views"
                } else {
                    if 999_999 >= countView && countView > 999 {
                        numberView = String(countView / 1_000) + "K views"
                    } else {
                        numberView += " views"
                    }
                }
            } else {
                numberView += " view"
            }
        }
        return numberView
    }
}
