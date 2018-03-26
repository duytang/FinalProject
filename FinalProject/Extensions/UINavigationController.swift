//
//  File.swift
//  ATMCard
//
//  Created by framgia on 5/18/17.
//  Copyright © 2017 Vo Nguyen Chi Phuong. All rights reserved.
//

import UIKit

extension UINavigationController {
    func popToViewController(animated: Bool) {
        _ = self.popViewController(animated: animated)
    }

    func titleColor(color: UIColor) {
        navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: color]
    }
}
