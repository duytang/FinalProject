//
//  CategoryInput.swift
//  FinalProject
//
//  Created by Kieu Nhi on 3/31/18.
//  Copyright © 2018 Kieu Nhi. All rights reserved.
//

import Foundation

class CategoryInput: BaseInput {
    override init() {
        super.init()
        self.url = APIPath.API.category
        self.method = .get
        self.useAccessToken = false
        self.parameter = ["part": "snippet", "regionCode": App.regionCode,
                          "key": Key.apiKey]
    }
}
