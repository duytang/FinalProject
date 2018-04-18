//
//  Label.swift
//  Blank Project
//
//  Created by Kieu Nhi on 5/31/17.
//  Copyright © 2017 Kieu Nhi. All rights reserved.
//

import UIKit
//Use label for font Japanese 
class Label: UILabel {

    var edgeInsets: UIEdgeInsets = UIEdgeInsets(top: -1.24, left: 0, bottom: 0, right: 0)
    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        var rect = super.textRect(forBounds: UIEdgeInsetsInsetRect(bounds, edgeInsets), limitedToNumberOfLines: numberOfLines)
        rect.size.height += 2
        return rect
    }

    override func drawText(in rect: CGRect) {
        super.drawText(in: UIEdgeInsetsInsetRect(rect, edgeInsets))
    }
}
