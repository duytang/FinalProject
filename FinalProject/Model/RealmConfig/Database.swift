//
//  Database.swift
//  GODI Business
//
//  Created by framgia on 7/17/17.
//  Copyright © 2017 GODI. All rights reserved.
//

import Foundation
import Realm
import ObjectMapper
import RealmSwift

class Database {

    static var shared = Database()

    func getAndSaveLocalDatabase(completion: @escaping ServiceCompletion) {
        let categoryResult = RealmManager.shared.objects((Category.self))
        if categoryResult.isEmpty {
            let input = CategoryInput(region: "VN")
            Services.categoryService.getCategories(input: input, completion: { (result) in
                switch result {
                case .success(let data):
                    if let object = data as? JSObject,
                        let categories = Mapper<Category>().mapArray(JSONObject: object["items"]) {
                        RealmManager.shared.write(action: { (realm) in
                            categories.forEach({ (category) in
                                if let id = Int(category.id) {
                                    if id < 30 && id != 18 && id != 19 && id != 21 && id != 22 {
                                        realm.add(category)
                                    }
                                }
                            })
                        })
                        completion(.success(categories))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            })
        }
    }
}
