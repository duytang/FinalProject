//
//  ForgotInput.swift
//  Coffee Bussiness
//
//  Created by framgia on 6/13/17.
//  Copyright © 2017 Coffee. All rights reserved.
//

import Foundation

class ForgotInput: BaseInput {

    init(phone: String) {
        super.init()
        self.url = APIPath.Login.forgot
        self.method = .post
        self.useAccessToken = false
        self.parameter = ["phone_number": phone]
    }
}
