//
//  File.swift
//  ATMCard
//
//  Created by framgia on 5/16/17.
//  Copyright © 2017 Vo Nguyen Chi Phuong. All rights reserved.
//

import Foundation

class DateFormat {
    /** yyyy-MM-dd HH:mm:ss */
    static var DateTime24 = "yyyy-MM-dd HH:mm:ss"
    /** yyyy-MM-dd HH:mm:ss Z*/
    static var DateTime24Z = "yyyy-MM-dd HH:mm:ss Z"
    /** yyyy-MM-dd hh:mm:ss a */
    static var DateTime12 = "yyyy-MM-dd hh:mm:ss a"
    /** yyyy-MM-dd hh:mm:ss a Z*/
    static var DateTime12Z = "yyyy-MM-dd hh:mm:ss a Z"
    /** yyyy-MM-dd HH:mm */
    static var DateTime24NoSec = "yyyy-MM-dd HH:mm"
    /** yyyy-MM-dd hh:mm a */
    static var DateTime12NoSec = "yyyy-MM-dd hh:mm a"
    /** yyyy-MM-dd */
    static var Date = "yyyy-MM-dd"
    /** HH:mm:ss */
    static var Time24 = "HH:mm:ss"
    /** hh:mm:ss a */
    static var Time12 = "hh:mm:ss a"
    /** HH:mm */
    static var Time24NoSec = "HH:mm"
    /** hh:mm a */
    static var Time12NoSec = "hh:mm a"

    /** yyyy-MM-dd'T'HH:mm:ss */
    static var TDateTime = "yyyy-MM-dd'T'HH:mm:ss"
    /** yyyy-MM-dd'T'HH:mm:ss.SSS'Z' */
    static var TDateTime3 = "yyyy-MM-dd'T'HH:mm:ss.SSS"
    /** yyyy-MM-dd'T'HH:mm:ss.SSSSSS */
    static var TDateTime6 = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"

    /** yyyy-MM-dd'T'HH:mm:ss'Z' */
    static var TZDateTime = "yyyy-MM-dd'T'HH:mm:ss'Z'"
    /** yyyy-MM-dd'T'HH:mm:ss.SSS'Z' */
    static var TZDateTime3 = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    /** yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z' */
    static var TZDateTime6 = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z'"
}

// MARK: - Date
extension Date {
    func convertDatetoJapanString(format: String? = nil) -> String {
        let dateFormatter = DateFormatter()
        if let format = format {
            dateFormatter.dateFormat = format
        } else {
            dateFormatter.dateStyle = DateFormatter.Style.long
        }
        dateFormatter.locale = Locale(identifier: "ja_JP")
        return dateFormatter.string(from: self)
    }

    func timeAgo() -> String {
        let minuteInterval: TimeInterval = 60
        let hourInterval: TimeInterval = 3600
        let dayInterval: TimeInterval = hourInterval * 24
        let timeInterval = abs(self.timeIntervalSince(Date()))
        if timeInterval < hourInterval {
            let minute = floor(timeInterval / minuteInterval)
            return "\(Int(minute == 0 ? 1 : minute))分前"
        } else if timeInterval < dayInterval {
            let hour = floor(timeInterval / hourInterval)
            return "\(Int(hour))時間前"
        } else if timeInterval <= dayInterval * 7 {
            let day = floor(timeInterval / dayInterval)
            return "\(Int(day))日前"
        } else {
            return self.toString(format: "yyyy/MM/dd", localized: false)
        }
    }
}

// MARK: - TimeInterval
extension TimeInterval {
    var time: String {
        var mm = Int(trunc(self / 60))
        let hh = mm / 60
        mm %= 60
        if hh < 1 {
            return "\(mm)m"
        } else {
            return "\(hh)h\(mm)m"
        }
    }

    var clock: String {
        var duration = Int(self)
        let hour = duration / 3600
        duration %= 3600
        let mins = duration / 60
        duration %= 60
        let secs = duration
        let suffix = String(format: "%@%d:%@%d", mins > 9 ? "" : "0", mins, secs > 9 ? "" : "0", secs)
        let prefix = hour > 0 ? String(format: "%@%d:", hour > 9 ? "" : "0", hour) : ""
        return String(format: "%@%@", prefix, suffix)
    }
}

// MARK: - String
extension String {
    func toDate(format: String, localized: Bool) -> Date {
        return Date(str: self, format: format, localized: localized)
    }
}

// MARK: - Date
extension Date {
    static var zero: Date {
        var comps = DateComponents(year: 0, month: 1, day: 1)
        comps.timeZone = TimeZone.utcTimeZone()
        var calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        calendar.timeZone = TimeZone.utcTimeZone()
        return calendar.date(from: comps) ?? Date()
    }

    init(str: String, format: String, localized: Bool) {
        let fmt = DateFormatter.fromFormat(format: format)
        fmt.timeZone = localized ? TimeZone.current : TimeZone.utcTimeZone()
        if let date = fmt.date(from: str) {
            self.init(timeInterval: 0, since: date)
        } else {
            self.init(timeInterval: 0, since: Date.zero)
        }
    }

    func toString(format: String, localized: Bool) -> String {
        let fmt = DateFormatter.fromFormat(format: format)
        fmt.timeZone = localized ? TimeZone.current : TimeZone.utcTimeZone()
        return fmt.string(from: self)
    }

}

// MARK: - TimeZone
extension TimeZone {
    static func utcTimeZone() -> TimeZone {
        return TimeZone(secondsFromGMT: 0)!
    }
}

// MARK: - NSDateComponents
extension NSDateComponents {
    convenience init(year: Int, month: Int, day: Int, hour: Int = 0, minute: Int = 0, sec: Int = 0, nsec: Int = 0) {
        self.init()
        self.year = year
        self.month = month
        self.day = day
        self.hour = hour
        self.minute = minute
        self.second = sec
        self.nanosecond = nsec
    }
}

var fmts: [String: DateFormatter] = [String: DateFormatter]()
let lock = NSLock()

// MARK: - DateFormatter
extension DateFormatter {
    static func fromFormat(format: String!) -> DateFormatter {
        lock.lock()
        var fmt: DateFormatter!
        if let existFmt = fmts[format] {
            fmt = existFmt
        } else {
            fmt = DateFormatter()
            fmt.dateFormat = format
            fmts[format] = fmt
        }
        lock.unlock()
        return fmt
    }
}


struct DateRange {
    var start: Date!
    var end: Date!
}


