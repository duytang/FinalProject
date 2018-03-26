//
//  ArrayExtension.swift
//  Blank Project
//
//  Created by framgia on 5/31/17.
//  Copyright © 2017 Vo Nguyen Chi Phuong. All rights reserved.
//

import Foundation

extension Array {
    func indexOf(includeElement: (Element) -> Bool) -> Int? {
        for (index, value) in enumerated() {
            if includeElement(value) {
                return index
            }
        }
        return nil
    }
}
