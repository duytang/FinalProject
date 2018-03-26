//
//  BaseService.swift
//  Wellmeshi
//
//  Created by PhuongVNC on 11/15/16.
//  Copyright © 2016 Vo Nguyen Chi Phuong. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper

class BaseService {

    var accessToken: String? {
        return UserManager.shared.getUser()?.accessToken
    }

    func request(input: BaseInputProtocol, completion: @escaping ServiceCompletion) {

        if !reachability.isReachable() {
            completion(APIResult.failure(APIError.internetError))
            return
        }

        if let accessToken = accessToken, input.useAccessToken {
            input.header?["access-token"] = accessToken
        }

        _ = api.request(input: input, completion: completion)
    }

    func requestService(input: BaseInputProtocol, completion: @escaping ServiceCompletion) -> DataRequest? {

        if !reachability.isReachable() {
            completion(APIResult.failure(APIError.internetError))
            return nil
        }

        if let accessToken = accessToken, input.useAccessToken {
            input.header?["access-token"] = accessToken
        }

        return api.request(input: input, completion: completion)
    }

}
