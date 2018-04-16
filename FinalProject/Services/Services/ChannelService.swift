//
//  ChannelService.swift
//  FinalProject
//
//  Created by Kieu Nhi on 4/7/18.
//  Copyright © 2018 Kieu Nhi. All rights reserved.
//

import Foundation
import ObjectMapper

class ChannelService: BaseService {
    func channelDetail(input: BaseInput, completion: @escaping ServiceCompletion) {
        request(input: input) { (result) in
            switch result {
            case .success(let response):
                if let response = response as? NSDictionary,
                    let object = response as? JSObject,
                    let channels = Mapper<Channel>().mapArray(JSONObject: object["items"]) {
                    completion(.success(channels))
                } else {
                    completion(.failure(APIError.jsonError))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
