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

    init() {
        favoriteList = Array(RealmManager.shared.objects(FavoriteList.self))
    }

    func getData() {
        favoriteList = Array(RealmManager.shared.objects(FavoriteList.self))
    }

    func numberOfItems(inSection section: Int) -> Int {
        return favoriteList.count
    }

    func viewModelForItem(at indexPath: IndexPath) -> FavoriteCollectionViewModel {
        let viewModel = FavoriteCollectionViewModel(favoriteList: favoriteList[indexPath.row])
        return viewModel
    }
}
