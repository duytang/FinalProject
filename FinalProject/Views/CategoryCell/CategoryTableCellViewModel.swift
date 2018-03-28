//
//  CategoryTableCellViewModel.swift
//  FinalProject
//
//  Created by Duy Tang on 3/28/18.
//  Copyright © 2018 Duy Tang. All rights reserved.
//

import Foundation

final class CategoryTableCellViewModel {
    var nameCategory = ""

    init() { }

    init(category: String) {
        nameCategory = category
    }
}
