//
//  SearchViewModel.swift
//  FinalProject
//
//  Created by Kieu Nhi on 3/28/18.
//  Copyright © 2018 Kieu Nhi. All rights reserved.
//

import Foundation
import MVVM
import Alamofire
import SwifterSwift
import ObjectMapper

final class SearchViewModel: ViewModel {
    var suggestKeys: [String] = []
    var keyword = ""
    var videos: [Video] = []
    var nextPage = ""

    var searchRequest: Alamofire.Request?

    func searchVideoName(keyword: String, completion: @escaping DataResultCompletion) {
        let parameter: [String: String] = ["q": keyword]
        let api = APIPath.API.completeSearch
        searchRequest?.cancel()
        let encode: URLEncoding = .queryString
        searchRequest = request(api, method: .get, parameters: parameter, encoding: encode, headers: nil)
            .validate()
            .responseString(completionHandler: { [weak self](result) in
                guard let this = self else { return }
                this.suggestKeys.removeAll()
                guard let result = result.description.replace(pattern: "SUCCESS:", withString: "", ignoreCase: true) else { return }
                var value = result.trimmed.replacingOccurrences(of: "[", with: "")
                            .replacingOccurrences(of: "]", with: "")
                            .splitted(by: Character(","))
                if !value.isEmpty {
                    value.remove(at: 0)
                }
                let listName = value.map { (text) -> String in
                    let temp = text.replacingOccurrences(of: "\"", with: "")
                    let transform = "Any-Hex/Java"
                    let convertedString = temp.mutableCopy() as? NSMutableString
                    CFStringTransform(convertedString, nil, transform as NSString, true)
                    guard let result = convertedString else {
                        return ""
                    }
                    return result as String
                }

                this.suggestKeys = listName
                completion(.success)
            })
    }

    func searchVideo(from key: String, nextPage: String, completion: @escaping DataResultCompletion) {
        let input = SearchVideoInput(keyword: key, nextPage: nextPage)
        Services.videoService.relateVideos(input: input) { (result) in
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
                    self.videos = videos
                    completion(.success)
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
