//
//  Font.swift
//  Blank Project
//
//  Created by framgia on 6/5/17.
//  Copyright © 2017 Vo Nguyen Chi Phuong. All rights reserved.
//
import Foundation
import UIKit
struct Font {
    static var helveticaNeue = HelveticaNeue()
}

class HelveticaNeue: CustomFont {

    override var name: FontName {
        return .helveticaNeue
    }

    func normal(ofSize size: CGFloat) -> UIFont! {
        return CCFont(name: name, .regular, size)
    }

    func bold(ofSize size: CGFloat) -> UIFont! {
        return CCFont(name: name, .bold, size)
    }
}

// MARK: - Custom Font Table
/*
 Example: label.font = Font(.Lato, .Bold, 12)
 */
enum FontName: String {
    case helveticaNeue = "Helvetica Neue"

    var familyName: String {
        return "Helvetica Neue"
    }

}

enum FontType: String {
    case black = "-Black"
    case blackItalic = "-BlackItalic"
    case bold = "-Bold"
    case boldItalic = "-BoldItalic"
    case extraBold = "-ExtraBold"
    case extraBoldItalic = "-ExtraBoldItalic"
    case hairline = "-Hairline"
    case hairlineItalic = "-HairlineItalic"
    case heavy = "-Heavy"
    case heavyItalic = "-HeavyItalic"
    case italic = "-Italic"
    case light = "-Light"
    case lightItalic = "-LightItalic"
    case medium = "-Medium"
    case mediumItalic = "-MediumItalic"
    case regular = "-Regular"
    case semibold = "-Semibold"
    case semiboldItalic = "-SemiboldItalic"
    case thin = "-Thin"
    case thinItalic = "-ThinItalic"
    case ultra = "-Ultra"
}

enum PSDFontScale: CGFloat {
    case iPhone45 = 1.0
    case iPhone6 = 1.117
    case iPhone6p = 1.3
}

let fontScale: PSDFontScale = (Helper.isiPhone4 || Helper.isiPhone5 ? .iPhone45 : Helper.isiPhone6 ? .iPhone6 : .iPhone6p)

func CCFont(name: FontName, _ type: FontType, _ size: CGFloat) -> UIFont! {
    let fontName = name.rawValue + type.rawValue
    let fontSize = size * fontScale.rawValue
    let font = UIFont(name: fontName, size: fontSize)
    if let font = font {
        return font
    } else {
        // Console.log("\(fontName) is invalid font.", level: .Error)
        return UIFont.systemFont(ofSize: fontSize)
    }
}

class CustomFont: CustomStringConvertible {
    var name: FontName! { return nil }
    init() { }
    var description: String {
        if let name = name {
            let fonts = UIFont.fontNames(forFamilyName: name.familyName)
            return "\(fonts)"
        }
        return ""
    }
}
