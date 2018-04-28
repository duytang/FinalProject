//
//  FavoriteListViewModel.swift
//  FinalProject
//
//  Created by Kieu Nhi on 3/30/18.
//  Copyright © 2018 Kieu Nhi. All rights reserved.
//

import Foundation
import MVVM

final class FavoriteListViewModel: ViewModel {
    var favorite: FavoriteList?
    var videos: [Video] = []

    init() {}

    init(favorite: FavoriteList) {
        self.favorite = favorite
        self.videos = Array(favorite.listVideo)
    }

    func getFavoriteList() -> FavoriteList? {
        guard let favorite = favorite else { return nil }
        let data = RealmManager.shared.favorite(from: favorite.id)
        guard let favoriteList = data else { return nil }
       return favoriteList
    }

    func numberOfItems(inSection section: Int) -> Int {
        guard let favorite = favorite else { return 0 }
        return favorite.listVideo.count
    }

    func viewModelForItem(at indexPath: IndexPath) -> FavoriteListCellViewModel {
        guard favorite != nil else {
            fatalError("Cannot load favorite list")
        }
        let viewModel = FavoriteListCellViewModel(video: videos[indexPath.row])
        return viewModel
    }
}
