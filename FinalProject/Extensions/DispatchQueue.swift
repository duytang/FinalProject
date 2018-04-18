//
//  DispatchQueueExtension.swift
//  Blank Project
//
//  Created by Kieu Nhi on 5/22/17.
//  Copyright © 2017 Kieu Nhi. All rights reserved.
//

import UIKit

extension DispatchQueue {

    class func after(time: TimeInterval, _ block: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + time) {
            block()
        }
    }
}

class GCDGroup {
    var queue: DispatchQueue!
    var group: DispatchGroup!
    var allCompletion: (() -> Void)?

    init(thread: DispatchQueue) {
        queue = DispatchQueue(label: "DISPATCH_GROUP")
        queue.setTarget(queue: thread)
        group = DispatchGroup()

        group.notify(queue: .main) {
            self.allCompletion?()
        }
    }

    func addWork(_ work: @escaping (DispatchGroup) -> Void) {
        group.enter()
        // please add group.leave() in work. If you use group for service
        queue.async(group: group, execute: {
            work(self.group)
        })
    }

    func notify(action: @escaping () -> Void) {
        group.notify(queue: .main, execute: action)
    }
}
