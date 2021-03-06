//
//  CategoryViewModel.swift
//  FinalProject
//
//  Created by Kieu Nhi on 4/1/18.
//  Copyright © 2018 Kieu Nhi. All rights reserved.
//

import Foundation
import MVVM

final class CategoryViewModel: ViewModel {

    var datasource: [Category] = []

    init() { }

    init(datasource: [Category]) {
        self.datasource = datasource
    }

    func numberOfItems(inSection section: Int) -> Int {
        return datasource.count
    }

    func viewModelForItem(at indexPath: IndexPath) -> TitleViewModel {
        return TitleViewModel(title: datasource[indexPath.row].name)
    }

}
