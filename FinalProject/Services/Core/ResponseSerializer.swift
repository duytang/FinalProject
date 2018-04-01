//
//  Created by admin on 11/7/16.
//  Copyright © 2016 admin. All rights reserved.
//

import Alamofire

extension DataRequest {
    func response(completion: @escaping ServiceCompletion) {
        responseJSON { (data) -> Void in
            _ = data.request
            let result = data.result
            let response = data.response
            if let response = response {
                self.saveCookies(response: response)
            }

            backgroundQueue.addOperation({ () -> Void in
                if let error = result.error {
                    let apiError = APIError(code: -1, message: error.localizedDescription)
                    OperationQueue.main.addOperation {
                        completion(APIResult.failure(apiError))
                    }
                } else {
                    guard let response = response else { return }
                    switch response.statusCode {
                    case 200...299:
                        if let object = result.value as? JSObject {
                            OperationQueue.main.addOperation {
                                completion(APIResult.success(object))
                            }
                        } else if let array = result.value as? JSArray {
                            OperationQueue.main.addOperation {
                                completion(APIResult.success(array))
                            }
                        } else {
                            OperationQueue.main.addOperation {
                                completion(APIResult.failure(APIError.jsonError))
                            }
                        }
                    default:
                        var apiError = APIError(code: -1, message: "Handling error")
                        if let status = HTTPStatusCode(rawValue: response.statusCode) {
                            apiError = status.error
                        }
                        OperationQueue.main.addOperation {
                            completion(APIResult.failure(apiError))
                        }
                    }
                }
            })
        }
    }

    func saveCookies(response: HTTPURLResponse) {
        guard let headerFields = response.allHeaderFields as? [String: String] else { return }
        guard let URL = response.url else { return }
        let cookies = HTTPCookie.cookies(withResponseHeaderFields: headerFields, for: URL)
        HTTPCookieStorage.shared.setCookies(cookies, for: URL, mainDocumentURL: nil)
    }
}
