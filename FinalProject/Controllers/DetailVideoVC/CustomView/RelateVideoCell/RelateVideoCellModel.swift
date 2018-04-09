//
//  RelateVideoCellModel.swift
//  FinalProject
//
//  Created by Duy Tang on 4/7/18.
//  Copyright © 2018 Duy Tang. All rights reserved.
//

import Foundation

final class RelateVideoCellModel {
    var name = ""
    var image = ""
    var duration = ""
    var channelTitle = ""
    var numberView = ""

    init() {}

    init(video: Video) {
        name = video.name
        image = video.thumbnail
        duration = video.duration
        channelTitle = video.channelName
        numberView = video.numberView
    }
}
