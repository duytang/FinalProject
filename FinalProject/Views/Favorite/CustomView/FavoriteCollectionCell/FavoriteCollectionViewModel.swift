//
//  FavoriteCollectionViewModel.swift
//  FinalProject
//
//  Created by Kieu Nhi on 3/28/18.
//  Copyright © 2018 Kieu Nhi. All rights reserved.
//

import Foundation

final class FavoriteCollectionViewModel {
    var favoriteList: FavoriteList?

    init() {}

    init(favoriteList: FavoriteList) {
        self.favoriteList = favoriteList
    }
}
