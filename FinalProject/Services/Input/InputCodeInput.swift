//
//  InputCodeInput.swift
//  Coffee Bussiness
//
//  Created by framgia on 6/13/17.
//  Copyright © 2017 Coffee. All rights reserved.
//

import Foundation

class InputCodeInput: BaseInput {

    init(code: String, phone: String) {
        super.init()
        self.url = APIPath.Login.forgot + "/\(code)"
        self.method = .get
        self.useAccessToken = false
        self.parameter = ["phone_number": phone]
    }
}
