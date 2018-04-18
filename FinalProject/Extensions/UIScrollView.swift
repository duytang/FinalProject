//
//  UIScrollViewExtension.swift
//  Blank Project
//
//  Created by Kieu Nhi on 5/29/17.
//  Copyright © 2017 Kieu Nhi. All rights reserved.
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
