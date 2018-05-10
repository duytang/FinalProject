//
//  RealmManager.swift
//  GODI Business
//
//  Created by Kieu Nhi on 7/17/17.
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

    func video(from id: String) -> Video? {
        let videos = Array(realm.objects(Video.self).filter("idVideo=%@", id))
        guard !videos.isEmpty, let video = videos.first else { return nil }
        return video
    }

    func favorite(from id: Int) -> FavoriteList? {
        let favorites = Array(realm.objects(FavoriteList.self).filter("id=%@", id))
        guard !favorites.isEmpty, let favorite = favorites.first else { return nil }
        return favorite
    }

    func history(from id: String) -> History? {
        let histories = Array(realm.objects(History.self).filter("id=%@", id))
        guard !histories.isEmpty, let history = histories.first else { return nil }
        return history
    }

    func add(object: Object) {
        do {
            try realm.write {
                realm.add(object)
            }
        } catch { }
    }

    func write(action: (Realm) -> Void) {
        do {
            try realm.write {
                action(realm)
            }
        } catch {

        }
    }

    func delete(object: Object) {
        do {
            try realm.write {
                realm.delete(object)
            }
        } catch { }
    }

    func cleanAllData() {
        write { (realm) in
            realm.deleteAll()
        }
    }
}
