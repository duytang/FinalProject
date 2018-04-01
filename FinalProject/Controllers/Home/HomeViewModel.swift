//
//  HomeViewModel.swift
//  FinalProject
//
//  Created by Duy Tang on 3/27/18.
//  Copyright © 2018 Duy Tang. All rights reserved.
//

import Foundation
import MVVM
import ObjectMapper

final class HomeViewModel: ViewModel {
    var videos: [Video] = []
    var categories: [Category] = []
    var nextPage = ""
    var title = ""
    var limit = 10
    var idCategory = "0"

    func numberOfItems(inSection section: Int) -> Int {
        return videos.count
    }

    func viewModelForItem(at indexPath: IndexPath) -> ContentTableViewModel {
        let contentCellViewModel = ContentTableViewModel(video: videos[indexPath.row])
        return contentCellViewModel
    }
    func getCategories(completion: @escaping DataResultCompletion) {
        let categories = RealmManager.shared.objects(Category.self)
        self.categories = Array(categories)
        if !self.categories.isEmpty {
            guard let category = self.categories.first else { return }
            title = category.name
            idCategory = category.id
            getVideos(completion: { (result) in
                switch result {
                case .success:
                    completion(.success)
                case .failure(let error):
                    completion(.failure(error))
                }
            })
        } else {
            Database.shared.getAndSaveLocalDatabase(completion: { (result) in
                switch result {
                case .success(let data):
                    if let data = data as? [Category] {
                        self.categories = data
                        guard let category = self.categories.first else { return }
                        self.title = category.name
                        self.idCategory = category.id
                        self.getVideos(completion: { (result) in
                            switch result {
                            case .success:
                                completion(.success)
                            case .failure(let error):
                                completion(.failure(error))
                            }
                        })
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            })
        }
    }

    func getVideos(completion: @escaping DataResultCompletion) {
        let input = VideoInput(id: idCategory, region: "VN", limit: limit, pageToken: nextPage)
        Services.videoService.videoList(input: input) { (result) in
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
                print(error.message ?? "")
            }
        }
    }
}
