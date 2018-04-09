//
//  AppDelegate.swift
//  FinalProject
//
//  Created by Duy Tang on 3/26/18.
//  Copyright © 2018 Duy Tang. All rights reserved.
//

import UIKit
import ObjectMapper

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    static var shared: AppDelegate {
        guard let delegate = kApplication.delegate as? AppDelegate else { fatalError("Cannot cast the delegate") }
        return delegate
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let tabBar = TabbarController()
        window?.rootViewController = tabBar
        window?.makeKeyAndVisible()
        return true
    }
}
