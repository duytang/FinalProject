//
//  NSContraintExtension.swift
//  FinalProject
//
//  Created by Kieu Nhi on 4/8/18.
//  Copyright © 2018 Kieu Nhi. All rights reserved.
//

import UIKit

extension NSLayoutConstraint {
    var scaling: CGFloat {
        return constant * App.ratio
    }
}
