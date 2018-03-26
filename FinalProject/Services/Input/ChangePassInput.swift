//
//  ChangePassInput.swift
//  Coffee Bussiness
//
//  Created by framgia on 6/13/17.
//  Copyright © 2017 Coffee. All rights reserved.
//

import Foundation

class ChangePassInput: BaseInput {

    init(code: Code, newPass: String) {
        super.init()
        self.url = APIPath.Login.forgot + "/\(code.pin)"
        self.method = .put
        self.useAccessToken = false
        self.parameter = ["phone_number": code.phone,
                          "password": newPass,
                          "password_confirmation": newPass]
    }
}
