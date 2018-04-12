//
//  VideoInput.swift
//  FinalProject
//
//  Created by Duy Tang on 3/31/18.
//  Copyright © 2018 Duy Tang. All rights reserved.
//

import Foundation

class TrendingInput: BaseInput {
    init(limit: Int, pageToken: String) {
        super.init()
        self.url = APIPath.API.videos
        self.method = .get
        self.useAccessToken = false
        self.parameter = ["part": "snippet,contentDetails,statistics",
                          "regionCode": App.regionCode,
                          "maxResults": limit,
                          "chart": "mostPopular",
                          "pageToken": pageToken,
                          "key": Key.apiKey]
    }
}

class ChannelInput: BaseInput {
    init(id: String) {
        super.init()
        self.url = APIPath.API.channels
        self.method = .get
        self.useAccessToken = false
        self.parameter = ["part": "snippet",
                          "id": id,
                          "key": Key.apiKey]
    }
}

class VideoInput: BaseInput {
    init(id: String, limit: Int, pageToken: String) {
        super.init()
        self.url = APIPath.API.videos
        self.method = .get
        self.useAccessToken = false
        self.parameter = ["videoCategoryId": id,
                          "part": "snippet,contentDetails,statistics",
                          "regionCode": App.regionCode,
                          "maxResults": limit,
                          "chart": "mostPopular",
                          "pageToken": pageToken,
                          "key": Key.apiKey]
    }
}

class RelatedVideoInput: BaseInput {
    init(idVideo: String, limit: Int) {
        super.init()
        self.url = APIPath.API.relatedVideo
        self.method = .get
        self.useAccessToken = false
        self.parameter = ["part": "snippet",
                          "relatedToVideoId": idVideo,
                          "type": "video",
                          "maxResults": limit,
                          "key": Key.apiKey
                         ]
    }
}

class InfoVideoInput: BaseInput {
    init(id: String) {
        super.init()
        self.url = APIPath.API.videos
        self.method = .get
        self.useAccessToken = false
        self.parameter = ["part": "snippet,contentDetails,statistics",
                          "id": id,
                          "key": Key.apiKey
        ]
    }
}
