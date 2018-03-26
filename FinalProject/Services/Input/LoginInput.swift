//
//  LoginInput.swift
//  Coffee Bussiness
//
//  Created by framgia on 6/12/17.
//  Copyright © 2017 Coffee. All rights reserved.
//

import Foundation

class LoginInput: BaseInput {

    init(phone: String, password: String) {
        super.init()
        self.url = APIPath.Login.login
        self.method = .post
        self.useAccessToken = false
        self.parameter = ["phone_number": phone,
                          "password": password]

    }
}
