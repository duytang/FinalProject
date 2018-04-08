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
    var isLoadMore = false

    func getListTrending(completion: @escaping DataResultCompletion) {
        isLoadMore = false
        let input = TrendingInput(limit: 10, pageToken: nextPage)
        Services.videoService.trendingList(input: input) { [weak self](result) in
            guard let this = self else { return }
            switch result {
            case .success(let data):
                if this.nextPage.isEmpty {
                    this.videos = []
                }
                if let object = data as? JSObject, let videos = Mapper<Video>().mapArray(JSONObject: object["items"]) {
                    if let nextPage = object["nextPageToken"] as? String, !nextPage.isEmpty {
                        this.nextPage = nextPage
                        this.isLoadMore = true
                    } else {
                        this.nextPage = ""
                        this.isLoadMore = false
                    }

                    for video in videos {
                        let channelInput = ChannelInput(id: video.channelId)
                        Services.channelService.channelDetail(input: channelInput, completion: { (result) in
                            switch result {
                            case .success(let channels):
                                if let channels = channels as? [Channel], !channels.isEmpty {
                                    video.channelThumnail = channels[0].imageUrl
                                }
                                completion(.success)
                            case .failure(let error):
                                completion(.failure(error))
                            }
                        })
                    }
                    this.videos.append(contentsOf: videos)
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
