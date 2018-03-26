//
//  LogoutInput.swift
//  Coffee Bussiness
//
//  Created by framgia on 6/13/17.
//  Copyright © 2017 Coffee. All rights reserved.
//

import Foundation

class LogoutInput: BaseInput {

    override init() {
        super.init()
        self.url = APIPath.Login.logout
        self.method = .post
        self.parameter = ["query": "mutation{signOut(input:{auth: \"\"}"]
    }
}
