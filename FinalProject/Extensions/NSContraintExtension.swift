//
//  NSContraintExtension.swift
//  FinalProject
//
//  Created by Duy Tang on 4/8/18.
//  Copyright © 2018 Duy Tang. All rights reserved.
//

import UIKit

extension NSLayoutConstraint {
    var scaling: CGFloat {
        return constant * App.ratio
    }
}
