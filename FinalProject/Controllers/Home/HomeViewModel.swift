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

    // MARK: - Get list Categries
    func getCategories(completion: @escaping DataResultCompletion) {
        let videoCategories = Array(RealmManager.shared.objects(Category.self))
        if !videoCategories.isEmpty {
            categories = videoCategories
            title = categories[0].name
            idCategory = categories[0].id
            completion(.success)
        } else {
            let input = CategoryInput()
            Services.categoryService.getCategories(input: input, completion: { [weak self](result) in
                guard let this = self else { return }
                switch result {
                case .success(let data):
                    if let object = data as? JSObject,
                        let categories = Mapper<Category>().mapArray(JSONObject: object["items"]) {
                        RealmManager.shared.write(action: { (realm) in
                            categories.forEach({ (category) in
                                if let id = Int(category.id) {
                                    if id < 30 && id != 18 && id != 19 && id != 21 && id != 22 {
                                        this.categories.append(category)
                                        realm.add(category)
                                    }
                                }
                            })
                        })
                        this.title = this.categories[0].name
                        this.idCategory = this.categories[0].id
                    }
                    completion(.success)
                case .failure(let error):
                    completion(.failure(error))
                }
            })
        }
    }

    // MARK: - Get list videos
    func getVideos(completion: @escaping DataResultCompletion) {
        isLoadMore = false
        let input = VideoInput(id: idCategory, limit: limit, pageToken: nextPage)
        Services.videoService.videoList(input: input) { [weak self](result) in
            guard let this = self else { return }
            switch result {
            case .success(let data):
                if this.nextPage.isEmpty {
                    this.videos = []
                }
                if let object = data as? JSObject,
                    let nextPage = object["nextPageToken"] as? String,
                    let videos = Mapper<Video>().mapArray(JSONObject: object["items"]) {
                    this.nextPage = !nextPage.isEmpty ?  nextPage : ""
                    this.isLoadMore = !nextPage.isEmpty
                    if videos.isEmpty {
                        completion(.success)
                    } else {
                        videos.forEach { (video) in
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
