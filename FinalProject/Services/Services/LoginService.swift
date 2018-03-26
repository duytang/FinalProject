//
//  LoginService.swift
//  Coffee Bussiness
//
//  Created by framgia on 6/12/17.
//  Copyright © 2017 Coffee. All rights reserved.
//

import Foundation
import ObjectMapper

class LoginService: BaseService {

    func login(input: BaseInput, completion: @escaping ServiceCompletion) {
        request(input: input) { (result) in
            switch result {
            case .success(let json):
                if let json = json as? JSObject, let user = Mapper<User>().map(JSONObject: json) {
                    completion(APIResult.success(user))
                } else {
                    completion(APIResult.failure(APIError.jsonError))
                }
                break
            case .failure(let error):
                completion(APIResult.failure(error))
                break

            }
        }
    }

    func forgot(input: BaseInput, completion: @escaping ServiceCompletion) {
        request(input: input) { (result) in
            switch result {
            case .success(let json):
                if let json = json as? JSObject, let notice = json["notice"] as? String {
                    completion(APIResult.success(notice))
                } else {
                    completion(APIResult.failure(APIError.jsonError))
                }
                break
            case .failure(let error):
                completion(APIResult.failure(error))
                break

            }
        }
    }

    func changePassword(input: BaseInput, completion: @escaping ServiceCompletion) {
        request(input: input) { (result) in
            switch result {
            case .success(let json):
                if let json = json as? JSObject, let notice = json["notice"] {
                    completion(APIResult.success(notice))
                } else {
                    completion(APIResult.failure(APIError.jsonError))
                }
                break
            case .failure(let error):
                completion(APIResult.failure(error))
                break

            }
        }
    }

    func validCode(input: BaseInput, completion: @escaping ServiceCompletion) {
        request(input: input) { (result) in
            switch result {
            case .success(let json):
                if let json = json as? JSObject, let code = Mapper<Code>().map(JSONObject: json) {
                    completion(APIResult.success(code))
                } else {
                    completion(APIResult.failure(APIError.jsonError))
                }
                break
            case .failure(let error):
                completion(APIResult.failure(error))
                break

            }
        }
    }

    func logout(input: BaseInput, completion: @escaping ServiceCompletion) {
        request(input: input) { (result) in
            switch result {
            case .success( _):
                UserManager.shared.logout()
                break
            case .failure(let error):
                completion(APIResult.failure(error))
                break

            }
        }

    }

}
