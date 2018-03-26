//
//  LocalNotificationManager.swift
//  Blank Project
//
//  Created by framgia on 5/26/17.
//  Copyright © 2017 Vo Nguyen Chi Phuong. All rights reserved.
//

import UIKit
import UserNotifications

class LocalNotificationManager {

    let identifier = "LocalNotification"
    static let shared = LocalNotificationManager()

    func addNotification(notification: UILocalNotification) {
        
        if #available(iOS 10.0, *) {
            let notificationCenter = UNUserNotificationCenter.current()
            let request = convert(local: notification)
            notificationCenter.add(request, withCompletionHandler: nil)
        } else {
            kApplication.scheduleLocalNotification(notification)
        }

    }

    func removeNotification(notification: UILocalNotification) {
        if #available(iOS 10.0, *) {
            let notificationCenter = UNUserNotificationCenter.current()
            let identifier =  "\(self.identifier)_\(notification.fireDate!.toString(format: DateFormat.DateTime24, localized: true))"
            notificationCenter.removePendingNotificationRequests(withIdentifiers: [identifier])
        } else {
            kApplication.cancelLocalNotification(notification)
        }

    }

    func removeAll() {
         if #available(iOS 10.0, *) {
            let notificationCenter = UNUserNotificationCenter.current()
            notificationCenter.removeAllPendingNotificationRequests()
         } else {
            kApplication.cancelAllLocalNotifications()
        }

    }

    @available(iOS 10.0, *)
    private func convert(local: UILocalNotification) -> UNNotificationRequest {
        let content = UNMutableNotificationContent()
        content.title = local.alertAction ?? ""
        content.body = local.alertBody ?? ""
        content.badge = NSNumber(value: local.applicationIconBadgeNumber)

        var trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        if let date = local.fireDate {
            let timeInterval = date.timeIntervalSinceNow
            trigger =  UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        }
        let identifier =  "\(self.identifier)_\(local.fireDate!.toString(format: DateFormat.DateTime24, localized: true))"
        let notificationRequest = UNNotificationRequest(identifier: identifier,
                                                        content: content, trigger: trigger)
        return notificationRequest

    }

}
