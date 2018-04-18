//
//  RealmConfig.swift
//  Coffee Bussiness
//
//  Created by Kieu Nhi on 6/15/17.
//  Copyright © 2017 Coffee. All rights reserved.
//

import Foundation
import RealmSwift

enum RealmConfig {
    case main
    case `static`

    var config: Realm.Configuration {
        switch self {
        case .main:
            return RealmConfig.mainConfig
        case .static:
            return RealmConfig.staticConfig
        }
    }

    private static var mainConfig: Realm.Configuration {
        return Realm.Configuration(schemaVersion: 0, migrationBlock: { (_, _) in

        }, deleteRealmIfMigrationNeeded: false)
    }
    private static var staticConfig: Realm.Configuration {
        return  Realm.Configuration(fileURL: nil, readOnly: true)
    }
}
