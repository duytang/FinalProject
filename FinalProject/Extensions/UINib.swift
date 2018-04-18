//
//  UINibExtension.swift
//  Blank Project
//
//  Created by Kieu Nhi on 5/22/17.
//  Copyright © 2017 Kieu Nhi. All rights reserved.
//

import UIKit

extension UINib {
    static func nib(named nibName: String) -> UINib {
        return UINib(nibName: nibName, bundle: nil)
    }
}
