//
//  History.swift
//  FinalProject
//
//  Created by Duy Tang on 4/22/18.
//  Copyright © 2018 Duy Tang. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift
import Realm

final class History: Video {
    @objc dynamic var video: Video?
    @objc dynamic var time: String = ""
    @objc dynamic var day: String = ""

    required init?(map: Map) {
        super.init()
    }

    required init() {
        super.init()
    }

    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }

    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }

    init(video: Video, time: String, day: String) {
        super.init()
        self.video = video
        self.time = time
        self.day = day
    }
}
