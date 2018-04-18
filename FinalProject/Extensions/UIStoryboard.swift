//
//  UIStoryboardExtension.swift
//  Blank Project
//
//  Created by Kieu Nhi on 5/29/17.
//  Copyright © 2017 Kieu Nhi. All rights reserved.
//

import UIKit

enum Storyboard: String {
    case main = "Main"
    case user = "User"
}

extension UIStoryboard {
    static func mainStoryboard(_ identifier: String = "") -> UIViewController {
        return  identifier.isEmpty ? loadInitial(from: .main) : load(from: .main, identifier: identifier)    }

    static func userStoryboard(_ identifier: String = "") -> UIViewController {
        return identifier.isEmpty ? loadInitial(from: .user) : load(from: .user, identifier: identifier)
    }
}

extension UIStoryboard {

    static func load(from storyboard: Storyboard, identifier: String) -> UIViewController {
        let uiStoryboard = UIStoryboard(name: storyboard.rawValue, bundle: nil)
        return uiStoryboard.instantiateViewController(withIdentifier: identifier)
    }

    static func loadInitial(from storyboard: Storyboard) -> UIViewController {
        let uiStoryboard = UIStoryboard(name: storyboard.rawValue, bundle: nil)
        guard let viewController = uiStoryboard.instantiateInitialViewController() else {
            fatalError("Choose initial view controlelr for \(storyboard.rawValue)")
        }
        return viewController
    }

}

extension UIStoryboardSegue {
    func destination<T: UIViewController>(aClass: T.Type) -> T {
        guard let controller = destination as? T else {
            fatalError("Destination view controller isn't \(T.className)")
        }
        return controller
    }
}
