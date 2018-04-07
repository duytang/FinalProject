//
//  FavoriteViewModel.swift
//  FinalProject
//
//  Created by Duy Tang on 3/28/18.
//  Copyright © 2018 Duy Tang. All rights reserved.
//

import Foundation
import MVVM

final class FavoriteViewModel: ViewModel {
    var favoriteList: [FavoriteList] = []

    func numberOfItems(inSection section: Int) -> Int {
        return favoriteList.count
    }
}
