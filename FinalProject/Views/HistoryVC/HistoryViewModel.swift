//
//  HistoryViewModel.swift
//  FinalProject
//
//  Created by Kieu Nhi on 3/29/18.
//  Copyright © 2018 Kieu Nhi. All rights reserved.
//

import Foundation
import MVVM

final class HistoryViewModel: ViewModel {
    var histories: [[History]] = []
    var dates: [String] = []

    func getData() {
        let histories = Array(RealmManager.shared.objects(History.self))
        guard let item = histories.first else { return }
        var day = item.time
        dates.append(day)
        for history in histories {
            if history.time != day {
                dates.append(history.time)
                day = history.time
            }
        }

        for date in dates.reversed() {
            let videos = histories.filter({ (history) -> Bool in
                return history.time == date
            })
            self.histories.append(videos.reversed())
        }
    }

    func numberOfItems(inSection section: Int) -> Int {
        return histories[section].count
    }

    func viewModelForItem(at indexPath: IndexPath) -> FavoriteListCellViewModel {
        let viewModel = FavoriteListCellViewModel()
        return viewModel
    }
}
