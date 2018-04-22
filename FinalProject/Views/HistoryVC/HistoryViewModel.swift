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
    var histories: [History] = []

    func getData() {
        let histories = RealmManager.shared.objects(History.self)
        self.histories = Array(histories)
    }

    func numberOfItems(inSection section: Int) -> Int {
        return histories.count
    }

    func viewModelForItem(at indexPath: IndexPath) -> FavoriteListCellViewModel {
        let viewModel = FavoriteListCellViewModel()
        return viewModel
    }
}
