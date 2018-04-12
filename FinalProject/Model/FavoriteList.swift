//
//  FavoriteList.swift
//  FinalProject
//
//  Created by Duy Tang on 4/1/18.
//  Copyright © 2018 Duy Tang. All rights reserved.
//

import Foundation
import RealmSwift

final class FavoriteList: Object {
    @objc dynamic var id = 0
    @objc  dynamic var name = ""
    var listVideo = List<Video>()

    override static func primaryKey() -> String? {
        return "id"
    }
}
