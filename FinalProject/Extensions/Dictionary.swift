//
//  DictionaryExtension.swift
//  Blank Project
//
//  Created by framgia on 5/30/17.
//  Copyright © 2017 Vo Nguyen Chi Phuong. All rights reserved.
//

import Foundation

extension Dictionary {

    mutating func append(_ dict: [Key: Value]?) {
        guard let dict = dict else { return }
        for (key, value) in dict {
            self[key] = value
        }
    }

}
