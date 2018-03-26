//
//  DataExtension.swift
//  Blank Project
//
//  Created by framgia on 5/31/17.
//  Copyright © 2017 Vo Nguyen Chi Phuong. All rights reserved.
//

import Foundation

extension Data {
    func base64String() -> String {
        return "data:image/jpeg;base64," + base64EncodedString()
    }
}
