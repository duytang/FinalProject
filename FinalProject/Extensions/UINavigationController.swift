//
//  File.swift
//  ATMCard
//
//  Created by Kieu Nhi on 5/18/17.
//  Copyright © 2017 Kieu Nhi. All rights reserved.
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
