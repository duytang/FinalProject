//
//  ContentTableCellViewModel.swift
//  FinalProject
//
//  Created by Kieu Nhi on 3/28/18.
//  Copyright © 2018 Kieu Nhi. All rights reserved.
//

import Foundation

final class ContentTableViewModel {
    var id = ""
    var name = ""
    var image = ""
    var channelName = ""
    var channelImage = ""
    var numberView = ""
    var timeUpload = ""
    var duration = ""

    init() { }

    init(video: Video) {
        id = video.idVideo
        name = video.name
        image = video.thumbnail
        channelName = video.channelName
        channelImage = video.channelThumnail
        numberView = video.numberView
        timeUpload = video.timeUpload
        duration = video.duration
    }
}
