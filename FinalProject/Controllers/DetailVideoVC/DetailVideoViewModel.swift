//
//  DetailVideoViewModel.swift
//  FinalProject
//
//  Created by Duy Tang on 3/30/18.
//  Copyright © 2018 Duy Tang. All rights reserved.
//

import Foundation
import MVVM
import ObjectMapper

final class DetailVideoViewModel: ViewModel {
    var video: Video?
    var nextPage = ""

    var relatedVideos: [Video] = []

    init() {}

    init(video: Video) {
        self.video = video
    }

    func numberOfItems(inSection section: Int) -> Int {
        return relatedVideos.count + 2
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

    func getRelatedVideos(completion: @escaping DataResultCompletion) {
        guard let video = video else { return }
        let input = RelatedVideoInput(idVideo: video.idVideo, limit: 10, nextPage: nextPage)
        Services.videoService.relateVideos(input: input) { [weak self](result) in
            guard let this = self else { return }
            if this.nextPage.isEmpty {
                this.relatedVideos = []
            }
            switch result {
            case .success(let data):
                if let object = data as? JSObject,
                    let nextPage = object["nextPageToken"] as? String,
                    let videos = Mapper<Video>().mapArray(JSONObject: object["items"]) {
                    this.nextPage = !nextPage.isEmpty ? nextPage : ""
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
                    let channelInput = ChannelInput(id: videos[0].idVideo)
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
