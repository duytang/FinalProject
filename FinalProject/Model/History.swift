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

final class History: Object {
    @objc dynamic var id = ""
    @objc dynamic var name = ""
    @objc dynamic var thumbnail = ""
    @objc dynamic var numberView = ""
    @objc dynamic var channelName = ""
    @objc dynamic var channelThumnail = ""
    @objc dynamic var channelPublishedAt = ""
    @objc dynamic var descript = ""
    @objc dynamic var time = ""
    @objc dynamic var day = ""

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
        self.id = video.idVideo
        self.name = video.name
        self.thumbnail = video.thumbnail
        self.numberView = video.numberView
        self.channelName = video.channelName
        self.channelThumnail = video.channelThumnail
        self.channelPublishedAt = video.channelPublishedAt
        self.descript = video.descript
        self.time = time
        self.day = day
    }
}
