//
//  Int.swift
//  Blank Project
//
//  Created by framgia on 5/31/17.
//  Copyright © 2017 Vo Nguyen Chi Phuong. All rights reserved.
//

import Foundation

extension Int {
    func loop( block: () -> Void) {
        for _ in 0 ..< self {
            block()
        }
    }

    var isEven: Bool {
        return (self % 2) == 0
    }

    var isOdd: Bool {
        return (self % 2) == 1
    }

    func clamp(range: Range<Int>) -> Int {
        return clamp(range.lowerBound,range.upperBound - 1)
    }

    func clamp(_ min: Int, _ max: Int) -> Int {
        return Swift.max(min, Swift.min(max, self))
    }

    var digits: [Int] {
        var result = [Int]()
        for char in String(self).characters {
            let string = String(char)
            if let toInt = Int(string) {
                result.append(toInt)
            }
        }
        return result
    }

    var abs: Int {
        return Swift.abs(self)
    }

    func gcd(_ num: Int) -> Int {
        return num == 0 ? self : num.gcd(self % num)
    }

    func lcm(_ num: Int) -> Int {
        return (self * num).abs / gcd(num)
    }

    var factorial: Int {
        return self == 0 ? 1 : self * (self - 1).factorial
    }

    var degreesToRadians: Double {
        return Double(self) * .pi / 180
    }

    var ordinal: String {
        let suffix: [String] = ["th", "st", "nd", "rd", "th"]
        var index = 0
        if self < 11 || self > 13 {
            index = Swift.min(suffix.count - 1, self % 10)
        }
        return String(format: "%zd%@", self, suffix[index])
    }
    
    static func random(min: Int = 0, max: Int) -> Int {
        return Int(arc4random_uniform(UInt32((max - min) + 1))) + min
    }
}

extension FloatingPoint {
    var degreesToRadians: Self {
        return self * .pi / 180
    }

    var radiansToDegrees: Self {
        return self * 180 / .pi
    }
}

