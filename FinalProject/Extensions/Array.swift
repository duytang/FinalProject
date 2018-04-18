//
//  ArrayExtension.swift
//  Blank Project
//
//  Created by Kieu Nhi on 5/31/17.
//  Copyright © 2017 Kieu Nhi. All rights reserved.
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
