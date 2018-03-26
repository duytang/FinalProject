//
//  Created by PhuongVNC on 11/7/16.
//  Copyright © 2016 Vo Nguyen Chi Phuong. All rights reserved.
//

import Alamofire

extension DataRequest {
    func response(completion: @escaping ServiceCompletion) {
        responseJSON { (data) -> Void in
            api.taskCount -= 1
            _ = data.request
            let result = data.result
            let response = data.response
            if let response = response {
                self.saveCookies(response: response)
            }
            let timing = data.timeline.requestCompletedTime - data.timeline.requestStartTime
            backgroundQueue.addOperation({ () -> Void in
                if let error = result.error {
                    let apiError = APIError(code: -1, message: error.localizedDescription)
                    OperationQueue.main.addOperation {
                        completion(APIResult.failure(apiError))
                    }
                    api.logResponse(stype: .error, response: response, value: nil, error: apiError,timimg: timing)
                } else {
                    switch response!.statusCode {
                    case 200...299:
                        if let object = result.value as? JSObject, let data = object["data"] as? JSObject {
                            OperationQueue.main.addOperation {
                                completion(APIResult.success(data))
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
                        api.logResponse(stype: .success, response: response, value: result.value, error: nil, timimg: timing)
                        break
                    default:
                        var apiError = APIError(code: -1, message:"Handling error")
                        if let json =  result.value as? JSObject, let error = json["errors"] as? String {
                            apiError.message = error
                        } else if let status = HTTPStatusCode(rawValue: response!.statusCode) {
                            apiError = status.error
                        }

                        OperationQueue.main.addOperation {
                            completion(APIResult.failure(apiError))
                        }
                        api.logResponse(stype: .error, response: response, value: nil, error: apiError, timimg: timing)
                        break
                    }
                }
            })
        }
    }

    func saveCookies(response: HTTPURLResponse) {
        guard let headerFields = response.allHeaderFields as? [String : String] else { return }
        guard let URL = response.url else { return }
        let cookies = HTTPCookie.cookies(withResponseHeaderFields: headerFields, for: URL)
        HTTPCookieStorage.shared.setCookies(cookies, for: URL, mainDocumentURL: nil)
    }
}
