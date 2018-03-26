//
//  UIScrollViewExtension.swift
//  Blank Project
//
//  Created by framgia on 5/29/17.
//  Copyright © 2017 Vo Nguyen Chi Phuong. All rights reserved.
//

import UIKit

extension UIScrollView {

    func isNearEndScrollView() -> Bool {
        if contentOffset.y <= 0 {
            return false
        }
        return contentOffset.y + 10 + frame.height >= contentSize.height
    }
}
