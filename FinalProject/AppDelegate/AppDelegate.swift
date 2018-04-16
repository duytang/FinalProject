//
//  AppDelegate.swift
//  FinalProject
//
//  Created by Kieu Nhi on 3/26/18.
//  Copyright © 2018 Kieu Nhi. All rights reserved.
//

import UIKit
import SwifterSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var thumbnailView: UIView?
    var videoDetailVC = DetailVideoViewController()

    static var shared: AppDelegate {
        guard let delegate = kApplication.delegate as? AppDelegate else { fatalError("Cannot cast the delegate") }
        return delegate
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        thumbnailView = UIView(frame: CGRect(x: SwifterSwift.screenWidth - 140, y: SwifterSwift.screenHeight - 140, width: 140, height: 80))
        let tabBar = TabbarController()
        window?.rootViewController = tabBar
        thumbnailView?.clipsToBounds = true
        if let thumbnail = thumbnailView {
            window?.rootViewController?.view.addSubview(thumbnail)
        }
        window?.makeKeyAndVisible()
        return true
    }
}
