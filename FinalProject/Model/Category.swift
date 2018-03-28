//
//  Category.swift
//  FinalProject
//
//  Created by Duy Tang on 3/28/18.
//  Copyright © 2018 Duy Tang. All rights reserved.
//

import Foundation
import ObjectMapper

final class Category: Mappable {
    @objc dynamic var id = 0
    @objc dynamic var name = ""

    init?(map: Map) { }

    func mapping(map: Map) {
        id <- map["id"]
        name <- map["snippet.title"]
    }
}
