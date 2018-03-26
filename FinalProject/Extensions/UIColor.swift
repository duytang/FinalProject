//
//  Color.swift
//  ATMCard
//
//  Created by framgia on 5/12/17.
//  Copyright © 2017 Vo Nguyen Chi Phuong. All rights reserved.
//

import UIKit

extension UIColor {
    static let mainColor = UIColor.colorRGB(red: 178, green: 81, blue: 83)
    static let navigationColor = UIColor.colorRGB(red: 178, green: 81, blue: 83)
    static let backgroundTextField = UIColor.colorRGB(red: 234, green: 239, blue: 242)
    static let textColor = UIColor.colorRGB(red: 73, green: 73, blue: 73)
    static let gradientColors = [UIColor.colorRGB(red: 0, green: 140, blue: 201), UIColor.colorRGB(red: 1, green: 158, blue: 168)]

}

extension UIColor {
    class func colorRGB(red: Int, green: Int, blue: Int) -> UIColor {
        return colorRGBA(red: red, green: green, blue: blue, alpha: 1)
    }

    class func colorRGBA(red: Int, green: Int, blue: Int, alpha: CGFloat) -> UIColor {
        return UIColor(red: CGFloat(red) / 255.0,
                       green: CGFloat(green) / 255.0,
                       blue: CGFloat(blue) / 255.0,
                       alpha: alpha)
    }

    class func colorHex(_ hex: String, alpha: CGFloat) -> UIColor {
        let hexInt = UIColor.intFromHex(hex)
        let color = UIColor(red: ((CGFloat) ((hexInt & 0xFF0000) >> 16)) / 255,
                            green: ((CGFloat) ((hexInt & 0xFF00) >> 8)) / 255,
                            blue: ((CGFloat) (hexInt & 0xFF)) / 255,
                            alpha: alpha)
        return color
    }

    func image(size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        let ctx = UIGraphicsGetCurrentContext()
        setFill()
        ctx?.fillPath()
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if let img = img {
            return img
        } else {
            return UIImage()
        }
    }

    private class func intFromHex(_ hex: String) -> UInt32 {
        var hexInt: UInt32 = 0
        let scanner = Scanner(string: hex)
        scanner.charactersToBeSkipped = CharacterSet(charactersIn: "#")
        scanner.scanHexInt32(&hexInt)
        return hexInt
    }

    func isDistinct(compare color: UIColor) -> Bool {
        guard let mainComponents = self.cgColor.components else { return false }
        guard let compareComponents = color.cgColor.components else { return false }
        let threshold: CGFloat = 0.25

        if fabs(mainComponents[0] - compareComponents[0]) > threshold ||
            fabs(mainComponents[1] - compareComponents[1]) > threshold ||
            fabs(mainComponents[2] - compareComponents[2]) > threshold {
            if fabs(mainComponents[0] - mainComponents[1]) < 0.03 && fabs(compareComponents[0] - compareComponents[2]) < 0.03 {
                if fabs(compareComponents[0] - compareComponents[1]) < 0.03 && fabs(compareComponents[0] - compareComponents[2]) < 0.03 {
                    return false
                }
            }
            return true
        }
        return false
    }
}
