//
//  CategoryService.swift
//  FinalProject
//
//  Created by Duy Tang on 3/31/18.
//  Copyright © 2018 Duy Tang. All rights reserved.
//

import Foundation

class CategoryService: BaseService {

    func getCategories(input: BaseInput, completion: @escaping ServiceCompletion) {
        request(input: input) { (result) in
            switch result {
            case .success(let response):
                if let response = response as? NSDictionary {
                    completion(APIResult.success(response))
                } else {
                    completion(APIResult.failure(APIError.jsonError))
                }
            case .failure(let error):
                completion(APIResult.failure(error))
            }
        }
    }
}
