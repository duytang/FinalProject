//
//  DetailVideoViewModel.swift
//  FinalProject
//
//  Created by Kieu Nhi on 3/30/18.
//  Copyright © 2018 Kieu Nhi. All rights reserved.
//

import Foundation
import MVVM
import ObjectMapper

final class DetailVideoViewModel: ViewModel {
    var video: Video?
    var limit = 10
    var isFavorite = false

    var relatedVideos: [Video] = []

    init() {}

    init(video: Video) {
        self.video = video
        self.isFavorite = checkFavorite()
    }

    func numberOfItems(inSection section: Int) -> Int {
        return relatedVideos.count + 3
    }

    func viewModelForInfoCell(at indexPath: IndexPath) -> InfoCellModel {
        let infoCellModel = InfoCellModel()
        return infoCellModel
    }

    func viewModelForDescriptionCell(at indexPath: IndexPath) -> DescriptionCellViewModel {
        let descriptionCellModel = DescriptionCellViewModel()
        return descriptionCellModel
    }

    func viewModelForRelateVideo(at indexPath: IndexPath) -> RelateVideoCellModel {
        let relateVideoCellModel = RelateVideoCellModel()
        return relateVideoCellModel
    }

    func checkFavorite() -> Bool {
        let videos = Array(RealmManager.shared.objects(Video.self))
        guard let video = video else { return false }
        for item in videos where item.idVideo == video.idVideo {
            return true
        }
        return false
    }

    func videoFavorite(from id: String) -> Video? {
        return RealmManager.shared.video(from: id)
    }

    func getRelatedVideos(completion: @escaping DataResultCompletion) {
        guard let video = video else { return }
        let input = RelatedVideoInput(idVideo: video.idVideo, limit: limit)
        Services.videoService.relateVideos(input: input) { [weak self](result) in
            guard let this = self else { return }
            this.relatedVideos = []
            switch result {
            case .success(let data):
                if let object = data as? JSObject,
                    let videos = Mapper<Video>().mapArray(JSONObject: object["items"]) {
                    videos.forEach {
                        this.getDetailVideo(id: $0.idVideo, completion: { (result) in
                            switch result {
                            case .success(let video):
                                if let videos = video as? [Video], !videos.isEmpty {
                                    this.relatedVideos.append(videos[0])
                                }
                                completion(.success)
                            case .failure(let error):
                                completion(.failure(error))
                            }
                        })
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func getDetailVideo(id: String, completion: @escaping ServiceCompletion) {
        let infoVideoInput = InfoVideoInput(id: id)
        Services.videoService.videoList(input: infoVideoInput, completion: { (result) in
            switch result {
            case .success(let data):
                if let object = data as? JSObject,
                    let videos = Mapper<Video>().mapArray(JSONObject: object["items"]), !videos.isEmpty {
                    let channelInput = ChannelInput(id: videos[0].channelId)
                    Services.channelService.channelDetail(input: channelInput, completion: { (result) in
                        switch result {
                        case .success(let channels):
                            if let channels = channels as? [Channel], !channels.isEmpty {
                                videos[0].channelThumnail = channels[0].imageUrl
                            }
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    })
                    completion(.success(videos))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
}
