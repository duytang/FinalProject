//
//  AddToFavoriteListViewModel.swift
//  FinalProject
//
//  Created by Kieu Nhi on 4/10/18.
//  Copyright © 2018 Kieu Nhi. All rights reserved.
//

import Foundation
import MVVM
import SwifterSwift

final class AddToFavoriteListViewModel: ViewModel {

    var favoriteList: [FavoriteList] = []
    var video: Video?

    init() { }

    init(video: Video) {
        self.video = video
    }

    func getData() {
        favoriteList = Array(RealmManager.shared.objects(FavoriteList.self))
    }

    func numberOfItems(inSection section: Int) -> Int {
        return favoriteList.count
    }

    func viewModelForItem(at indexPath: IndexPath) -> TitleViewModel {
        let viewModel = TitleViewModel(title: favoriteList[indexPath.row].name)
        return viewModel
    }

    func getId() -> Int {
        if favoriteList.isEmpty {
            return 0
        } else {
            guard let last = favoriteList.last else { return 0 }
            return last.id + 1
        }
    }

    func checkExist(id: String, videos: [Video]) -> Bool {
        for video in videos where video.idVideo == id {
                return true
        }
        return false
    }
}
