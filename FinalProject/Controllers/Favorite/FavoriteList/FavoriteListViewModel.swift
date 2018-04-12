//
//  FavoriteListViewModel.swift
//  FinalProject
//
//  Created by Duy Tang on 3/30/18.
//  Copyright © 2018 Duy Tang. All rights reserved.
//

import Foundation
import MVVM

final class FavoriteListViewModel: ViewModel {
    var title = ""
    var videos: [Video] = []

    init(title: String = "Favorite", videos: [Video] = []) {
        self.title = title
        self.videos = videos
    }

    func numberOfItems(inSection section: Int) -> Int {
        return videos.count
    }

    func viewModelForItem(at indexPath: IndexPath) -> FavoriteListCellViewModel {
        let viewModel = FavoriteListCellViewModel(video: videos[indexPath.row])
        return viewModel
    }
}
