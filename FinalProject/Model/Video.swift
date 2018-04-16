//
//  Video.swift
//  FinalProject
//
//  Created by Kieu Nhi on 3/28/18.
//  Copyright © 2018 Kieu Nhi. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift
import Realm

class Video: Object, Mappable {
    @objc dynamic var idVideo = ""
    @objc dynamic var idCategory = ""
    @objc dynamic var name = ""
    @objc dynamic var numberView = ""
    @objc dynamic var duration = ""
    @objc dynamic var channelId = ""
    @objc dynamic var channelName = ""
    @objc dynamic var channelThumnail = ""
    @objc dynamic var channelPublishedAt = ""
    @objc dynamic var descript = ""
    @objc dynamic var thumbnail = ""
    @objc dynamic var timeUpload = ""

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

    func mapping(map: Map) {
        var id = ""
        var image = ""
        id <- map["id"]
        if id == "" {
            idVideo <- map["id.videoId"]
        } else {
            idVideo = id
        }
        name <- map["snippet.title"]
        channelId <- map["snippet.channelId"]
        channelName <- map["snippet.channelTitle"]
        descript <- map["snippet.description"]
        timeUpload <- map["snippet.publishedAt"]
        image <- map["snippet.thumbnails.maxres.url"]
        if image.isEmpty {
            thumbnail <- map["snippet.thumbnails.high.url"]
        } else {
            thumbnail = image
        }
        duration <- map["contentDetails.duration"]
        numberView <- map["statistics.viewCount"]
    }
}
