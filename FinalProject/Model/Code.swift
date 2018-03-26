//
//  Code.swift
//  Coffee Bussiness
//
//  Created by framgia on 6/14/17.
//  Copyright © 2017 Coffee. All rights reserved.
//

import Foundation
import ObjectMapper

class Code: Mappable {
    var pin: String = ""
    var phone: String = ""

    required init?(map: Map) {}

    func mapping(map: Map) {
        pin <- map["pin"]
        phone <- map["phone_number"]
    }

}
