//
//  Video.swift
//  FinalProject
//
//  Created by Duy Tang on 3/28/18.
//  Copyright © 2018 Duy Tang. All rights reserved.
//

import Foundation
import ObjectMapper

final class Video: Mappable {
    @objc dynamic var idVideo = ""
    @objc dynamic var idCategory = ""
    @objc dynamic var title = ""
    @objc dynamic var viewCount = ""
    @objc dynamic var duration = ""
    @objc dynamic var channelId = ""
    @objc dynamic var channelTitle = ""
    @objc dynamic var channelThumnail = ""
    @objc dynamic var descript = ""
    @objc dynamic var thumbnail = ""
    @objc dynamic var timeUpload = ""

    init?(map: Map) { }

    func mapping(map: Map) {
        var id = ""
        id <- map["id"]
        if id == "" {
            idVideo <- map["id.videoId"]
        } else {
            idVideo = id
        }
        title <- map["snippet.title"]
        channelId <- map["snippet.channelId"]
        channelTitle <- map["snippet.channelTitle"]
        descript <- map["snippet.description"]
        timeUpload <- map["snippet.publishedAt"]
        thumbnail <- map["snippet.thumbnails.medium.url"]
        duration <- map["contentDetails.duration"]
        viewCount <- map["statistics.viewCount"]
    }
}
