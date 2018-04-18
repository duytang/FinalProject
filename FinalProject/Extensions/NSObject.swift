//
//  NSObject.swift
//  Blank Project
//
//  Created by Kieu Nhi on 5/31/17.
//  Copyright © 2017 Kieu Nhi. All rights reserved.
//

import Foundation

extension NSObject {
    @nonobjc var className: String {
        return String(describing: type(of: self))
    }

    @nonobjc class var className: String {
        return String(describing: type(of: self))
    }
}
