//
//  FavoriteList.swift
//  FinalProject
//
//  Created by Kieu Nhi on 4/1/18.
//  Copyright © 2018 Kieu Nhi. All rights reserved.
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
