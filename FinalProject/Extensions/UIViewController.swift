//
//  UIViewControllerExtension.swift
//  Blank Project
//
//  Created by framgia on 5/31/17.
//  Copyright © 2017 Vo Nguyen Chi Phuong. All rights reserved.
//

import UIKit

extension UIViewController {

    static func vc() -> Self? {
        let className = String(describing: type(of: self))
        let bundle = Bundle(for: self)
        return self.init(nibName: className, bundle: bundle)
    }

    func push(viewController: UIViewController, animation: Bool = true) {
        navigationController?.pushViewController(viewController, animated: animation)
    }

    var isTopViewController: Bool {
        if let topViewController = UIApplication.topViewController(), self == topViewController {
            return true
        } else {
            return false
        }
    }
}
