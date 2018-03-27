//
//  HomeViewModel.swift
//  FinalProject
//
//  Created by Duy Tang on 3/27/18.
//  Copyright © 2018 Duy Tang. All rights reserved.
//

import Foundation
import MVVM

final class HomeViewModel: ViewModel {
    func numberOfItems(inSection section: Int) -> Int {
        return 10
    }
    
    func viewModelForItem(at indexPath: IndexPath) -> CategoryCollectionViewModel {
        let collectionViewModel = CategoryCollectionViewModel(name: "Game")
        return collectionViewModel
    }
}

extension HomeViewModel {
    func getCategories() {
        let input = CategoryInput(region: "VN")
        Services.categoryService.getCategories(input: input) { (result) in
            print(result)
        }
    }
}
