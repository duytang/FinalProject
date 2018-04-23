//
//  SearchHistory.swift
//  FinalProject
//
//  Created by Duy Tang on 4/23/18.
//  Copyright © 2018 Duy Tang. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

final class SearchHistory: Object {
    @objc dynamic var name = ""
    @objc dynamic var time = ""

    required init() {
        super.init()
    }

    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }

    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }

    init(name: String, time: String) {
        super.init()
        self.name = name
        self.time = time
    }
}
