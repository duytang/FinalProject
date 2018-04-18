//
//  NSLock.swift
//  Blank Project
//
//  Created by Kieu Nhi on 5/31/17.
//  Copyright © 2017 Kieu Nhi. All rights reserved.
//

import Foundation

extension NSLock {
    func sync( block: () -> Void) {
        let locked = self.try()
        block()
        if locked {
            unlock()
        }
    }
}
