//
//  VideoService.swift
//  FinalProject
//
//  Created by Kieu Nhi on 3/31/18.
//  Copyright © 2018 Kieu Nhi. All rights reserved.
//

import Foundation

class VideoService: BaseService {
    func trendingList(input: BaseInput, completion: @escaping ServiceCompletion) {
        request(input: input) { (result) in
            switch result {
            case .success(let response):
                if let response = response as? NSDictionary {
                    completion(.success(response))
                } else {
                    completion(.failure(APIError.jsonError))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func videoList(input: BaseInput, completion: @escaping ServiceCompletion) {
        request(input: input) { (result) in
            switch result {
            case .success(let response):
                if let response = response as? NSDictionary {
                    completion(.success(response))
                } else {
                    completion(.failure(APIError.jsonError))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func relateVideos(input: BaseInput, completion: @escaping ServiceCompletion) {
        request(input: input) { (result) in
            switch result {
            case .success(let response):
                if let response = response as? NSDictionary {
                    completion(.success(response))
                } else {
                    completion(.failure(APIError.jsonError))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
