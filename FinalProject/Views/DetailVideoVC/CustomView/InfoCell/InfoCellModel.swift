//
//  InfoCellModel.swift
//  FinalProject
//
//  Created by Duy Tang on 4/7/18.
//  Copyright © 2018 Duy Tang. All rights reserved.
//

import Foundation

final class InfoCellModel {
    var videoName = ""
    var numberView = ""
    var channelImage = ""
    var channelName = ""
    var publicAt = ""

    init() {}

    init(video: Video?) {
        guard let video = video else { return }
        videoName = video.name
        numberView = video.numberView
        channelName = video.channelName
        channelImage = video.channelThumnail
        publicAt = video.channelPublishedAt
    }
}
