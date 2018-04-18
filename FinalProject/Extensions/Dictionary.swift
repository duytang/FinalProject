//
//  DictionaryExtension.swift
//  Blank Project
//
//  Created by Kieu Nhi on 5/30/17.
//  Copyright © 2017 Kieu Nhi. All rights reserved.
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
