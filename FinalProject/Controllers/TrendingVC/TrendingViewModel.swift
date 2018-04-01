//
//  TrendingViewModel.swift
//  FinalProject
//
//  Created by Duy Tang on 3/28/18.
//  Copyright © 2018 Duy Tang. All rights reserved.
//

import Foundation
import MVVM
import ObjectMapper

final class TrendingViewModel: ViewModel {
    var region = "VN"
    var videos: [Video] = []
    var nextPage = ""

    func getListTrending(completion: @escaping DataResultCompletion) {
        let input = TrendingInput(region: "VN", limit: 10, pageToken: nil)
        Services.videoService.trendingList(input: input) { (result) in
            switch result {
            case .success(let data):
                if let object = data as? JSObject, let nextPage = object["nextPageToken"] as? String,
                    let videos = Mapper<Video>().mapArray(JSONObject: object["items"]) {
                    self.nextPage = nextPage
                    for video in videos {
                        let channelInput = ChannelInput(id: video.channelId)
                        Services.videoService.channelDetail(input: channelInput, completion: { (result) in
                            switch result {
                            case .success(let data):
                                if let object = data as? JSObject, let channels = Mapper<Channel>().mapArray(JSONObject: object["items"]) {
                                    if let channel = channels.first {
                                        video.channelThumnail = channel.imageUrl
                                    }
                                    completion(.success)
                                }
                            case .failure(let error):
                                completion(.failure(error))
                            }
                        })
                    }
                    self.videos = videos
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func numberOfItems(inSection section: Int) -> Int {
        return videos.count
    }

    func viewModelForItem(at indexPath: IndexPath) -> ContentTableViewModel {
        let viewModel = ContentTableViewModel(video: videos[indexPath.row])
        return viewModel
    }
}
