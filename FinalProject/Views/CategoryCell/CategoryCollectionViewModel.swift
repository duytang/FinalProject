//
//  CategoryCollectionViewModel.swift
//  FinalProject
//
//  Created by Duy Tang on 3/27/18.
//  Copyright © 2018 Duy Tang. All rights reserved.
//

import Foundation
import MVVM

final class CategoryCollectionViewModel: ViewModel {
    var nameCategory = ""

    init(name: String) {
        self.nameCategory = name
    }

    init() { }
}
