//
//  DispatchQueueExtension.swift
//  Blank Project
//
//  Created by framgia on 5/22/17.
//  Copyright © 2017 Vo Nguyen Chi Phuong. All rights reserved.
//

import UIKit

extension DispatchQueue {

    class func after(time: TimeInterval, _ block: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + time) { 
            block()
        }
    }
}

class GCDGroup {
    var queue: DispatchQueue!
    var group: DispatchGroup!
    var allCompletion: (() -> ())?

    init(thread: DispatchQueue) {
        queue = DispatchQueue(label: "DISPATCH_GROUP")
        queue.setTarget(queue: thread)
        group = DispatchGroup()

        group.notify(queue: .main) { 
            self.allCompletion?()
        }
    }

    func addWork(_ work: @escaping (DispatchGroup) -> ()) {
        group.enter()
        // please add group.leave() in work. If you use group for service
        queue.async(group: group, execute: {
            work(self.group)
        })
    }
}
