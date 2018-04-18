//
//  Observerbale.swift
//  ATMCard
//
//  Created by Kieu Nhi on 5/17/17.
//  Copyright © 2017 Kieu Nhi. All rights reserved.
//

import Foundation

class Dynamic<T> {
    typealias Listenser = (T) -> Void
    var listener: Listenser?

    func bind(_ listener: Listenser?) {
        self.listener = listener
    }

    func bindAndFire(_ listener: Listenser?) {
        bind(listener)
        listener?(value)
    }

    var value: T {
        didSet {
            self.listener?(value)
        }
    }

    init(_ value: T) {
        self.value = value
    }
}
