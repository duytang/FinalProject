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
    var isLoadMore = false

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
        isLoadMore = false
        let input = VideoInput(id: idCategory, region: "VN", limit: limit, pageToken: nextPage)
        Services.videoService.videoList(input: input) { [weak self](result) in
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
                    this.videos.append(contentsOf: videos)
                } else {
                    let error = APIError(code: 400, message: "No data")
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
