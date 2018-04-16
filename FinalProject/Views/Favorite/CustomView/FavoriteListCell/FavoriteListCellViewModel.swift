//
//  FavoriteListCellViewModel.swift
//  FinalProject
//
//  Created by Kieu Nhi on 3/30/18.
//  Copyright © 2018 Kieu Nhi. All rights reserved.
//

import Foundation

final class FavoriteListCellViewModel {
    var video: Video?

    init() { }

    init(video: Video) {
        self.video = video
    }
}
