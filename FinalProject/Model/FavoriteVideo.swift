//
//  FavoriteVideo.swift
//  FinalProject
//
//  Created by Duy Tang on 4/1/18.
//  Copyright © 2018 Duy Tang. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper
import Realm

final class FavoriteVideo: Video {
    var idFavorite = 0
    var video: Video?

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

    init(video: Video, id: Int) {
        super.init()
        idFavorite = id
        self.video = video
    }
}
