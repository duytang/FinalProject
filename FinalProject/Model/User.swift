//
//  User.swift
//  Blank Project
//
//  Created by framgia on 5/22/17.
//  Copyright © 2017 Vo Nguyen Chi Phuong. All rights reserved.
//

import Foundation
import ObjectMapper

private enum UserKey: String {
    case accessToken = "accessToken"
    case type = "userType"
}

enum UserType: String {
    case bussiness = "Business"
    case driver = "Driver"
    case receptionist = "Receptionist"
}

class User: NSObject, Mappable, NSSecureCoding {

    var accessToken: String = ""
    var type: UserType {
        return UserType(rawValue: typeString) ?? .bussiness
    }
    private var typeString: String = ""
    static var supportsSecureCoding: Bool = true

    required init?(map: Map) {}

    func mapping(map: Map) {
        accessToken <- map["access_token"]
        typeString <- map["user_type"]
    }

    required init?(coder aDecoder: NSCoder) {
        if let accessToken = aDecoder.decodeObject(forKey: UserKey.accessToken.rawValue) as? String,
           let type = aDecoder.decodeObject(forKey: UserKey.type.rawValue) as? String {
            self.accessToken = accessToken
            self.typeString = type
        }
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(accessToken, forKey: UserKey.accessToken.rawValue)
        aCoder.encode(typeString, forKey: UserKey.type.rawValue)
    }
}
