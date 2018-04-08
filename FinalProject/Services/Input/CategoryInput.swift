//
//  CategoryInput.swift
//  FinalProject
//
//  Created by Duy Tang on 3/31/18.
//  Copyright © 2018 Duy Tang. All rights reserved.
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
