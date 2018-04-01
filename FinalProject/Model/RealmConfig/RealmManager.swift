//
//  RealmManager.swift
//  GODI Business
//
//  Created by framgia on 7/17/17.
//  Copyright © 2017 GODI. All rights reserved.
//

import Foundation
import RealmSwift

class RealmManager {

    static var shared = RealmManager()
    private lazy var realm: Realm = {
        do {
            let realm = try Realm()
            return realm
        } catch {
            fatalError("Cannot init Realm")
        }
    }()

    init() {
        Realm.Configuration.defaultConfiguration = RealmConfig.main.config
    }

    func clean<T: Object>(_ type: T.Type) {
        let object: Results<T> = objects(type)
        write { (realm) in
            realm.delete(object)
        }
    }

    func objects<T: Object>(_ type: T.Type) -> Results<T> {
        return realm.objects(type)
    }

//    func objects<T: Object>(_ type: T.Type) -> [T] {
//        return Array(realm.objects(type))
//    }

    func write(action: (Realm) -> Void) {
        do {
            try realm.write {
                action(realm)
            }
        } catch {

        }
    }

    func cleanAllData() {
        write { (realm) in
            realm.deleteAll()
        }
    }
}