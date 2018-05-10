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
        self.histories.removeAll()
        dates.removeAll()
        let histories = Array(RealmManager.shared.objects(History.self))
        guard let item = histories.first else { return }
        var day = item.day
        dates.append(day)
        for history in histories {
            if history.day != day {
                dates.append(history.day)
                day = history.day
            }
        }

        for date in dates.reversed() {
            let videos = histories.filter({ (history) -> Bool in
                return history.day == date
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
