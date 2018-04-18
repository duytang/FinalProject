//
//  CGRectExtension.swift
//  Blank Project
//
//  Created by Kieu Nhi on 5/22/17.
//  Copyright © 2017 Kieu Nhi. All rights reserved.
//

import UIKit

extension CGRect {
    var x: CGFloat {
        get {
            return origin.x
        }
        set {
            origin.x = newValue
        }

    }

    var y: CGFloat {
        get {
            return origin.y
        }
        set {
            origin.y = newValue
        }
    }

    var halfWidth: CGFloat { return width / 2 }
    var halfHeight: CGFloat { return height / 2 }

    var center: CGPoint {
        return CGPoint(x: width / 2, y: height / 2)
    }

}

extension UIScreen {
    var size: CGSize {
        return bounds.size
    }

    var iPhone5Screen: CGSize {
        return CGSize(width: 320, height: 568)
    }

    var iPhone6Or7Screen: CGSize {
        return CGSize(width: 375, height: 667)
    }

    var iPhone6Or7PlusScren: CGSize {
        return CGSize(width: 414, height: 736)
    }
}
