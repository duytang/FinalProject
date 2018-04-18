//
//  Optional.swift
//  Blank Project
//
//  Created by Kieu Nhi on 6/6/17.
//  Copyright © 2017 Kieu Nhi. All rights reserved.
//

import Foundation

extension Optional {
    var isNil: Bool {
        switch self {
        case .none:
            return true
        case .some:
            return false
        }
    }
}
