//
//  Helper.swift
//  ATMCard
//
//  Created by Kieu Nhi on 5/15/17.
//  Copyright © 2017 Kieu Nhi. All rights reserved.
//

import Foundation
import UIKit
import AudioToolbox
import SwifterSwift

let kUserDefault = UserDefaults.standard
let kNotification = NotificationCenter.default
let kApplication = UIApplication.shared
let kScreen = UIScreen.main

protocol Shake { }

extension Shake where Self: UIView {
    func shake() {
        let animation = CAKeyframeAnimation()
        animation.keyPath = "position.x"
        let x = self.center.x
        let values = [0, 10, -10, 10, -5, 5, -5, 0 ].map({ (number) -> CGFloat in
            return x + number
        })
        animation.values = values
        animation.keyTimes = [0, 0.125, 0.25, 0.375, 0.5, 0.625, 0.75, 0.875, 1]
        animation.duration = 0.4
        animation.isRemovedOnCompletion = false
        self.layer.add(animation, forKey: "shake")
    }
}

class Helper {
    static var isiPhone4: Bool {
        return kScreen.size.width == 320 && kScreen.size.height == 480
    }

    static var isiPhone5: Bool {
        return kScreen.size.width == 320 && kScreen.size.height == 568
    }

    static var isiPhone6: Bool {
        return kScreen.size.width == 375 && kScreen.size.height == 667
    }

    static var isiPhone6Plus: Bool {
        return kScreen.size.width == 414 && kScreen.size.height == 736
    }

    static var isiPhone: Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }

    static var isiPad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }

    class func vibration() {
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }

    class func readJSON(name: String) -> [String: Any]? {
        guard let path = Bundle.main.path(forResource: name, ofType: "json") else {
            return nil
        }
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            return try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
        } catch {
            return nil
        }
    }

    class func convertStringToAccount(string: String) -> String {
        var index = 1
        var accountNumber = ""
        string.forEach { (character) in
            if index % 4 == 0 {
                accountNumber.append(character)
                if index < string.count {
                    accountNumber.append(" ")
                }
            } else {
                accountNumber.append(character)
            }
            index += 1
        }
        return accountNumber
    }

    class func convertAccountToString(string: String) -> String {
        return string.replacingOccurrences(of: " ", with: "")
    }

    class func getCurrentTime() -> (day: String, time: String) {
        let date = Date()
        let currentDay = "\(date.month)-\(date.day)-\(date.year)"
        let currentTime = "\(date.hour):\(date.minute)"
        return (currentDay, currentTime)
    }
}
