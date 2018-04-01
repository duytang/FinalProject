//
//  Category.swift
//  FinalProject
//
//  Created by Duy Tang on 3/28/18.
//  Copyright © 2018 Duy Tang. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift
import Realm

final class Category: Object, Mappable {
    @objc dynamic var id = ""
    @objc dynamic var name = ""

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
        id <- map["id"]
        name <- map["snippet.title"]
    }
}
