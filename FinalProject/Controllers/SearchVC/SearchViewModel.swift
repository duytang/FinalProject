//
//  SearchViewModel.swift
//  FinalProject
//
//  Created by Duy Tang on 3/28/18.
//  Copyright © 2018 Duy Tang. All rights reserved.
//

import Foundation
import MVVM
import Alamofire
import SwifterSwift

final class SearchViewModel: ViewModel {
    var suggestKeys: [String] = []

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
}
