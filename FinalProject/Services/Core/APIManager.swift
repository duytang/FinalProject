//
//  APIManager.swift
//  Wellmeshi
//
//  Created by PhuongVNC on 11/7/16.
//  Copyright © 2016 Vo Nguyen Chi Phuong. All rights reserved.
//

import Foundation
import Alamofire
import Reachability


typealias ServiceResult = Alamofire.Result
typealias JSObject = [String: Any]
typealias JSArray = [JSObject]
typealias Completion = (ServiceResult<Any>) -> Void
typealias ServiceCompletion = (_ result: APIResult<Any>) -> Void
typealias Header = HTTPHeaders
typealias Parameter = Parameters

enum ResponseStyle {
    case success
    case error
}


enum APIResult<T> {
    case success(T)
    case failure(APIError)

    var isSuccess: Bool {
        switch self {
        case .success:
            return true
        case .failure:
            return false
        }
    }

    var isFailure: Bool {
        return !isSuccess
    }


    var value: T? {
        switch self {
        case .success(let value):
            return value
        case .failure:
            return nil
        }
    }

    var error: APIError? {
        switch self {
        case .success:
            return nil
        case .failure(let error):
            return error
        }
    }

}



let serialQueue: OperationQueue = {
    let queue = OperationQueue()
    queue.maxConcurrentOperationCount = 1
    return queue
}()

let backgroundQueue: OperationQueue = {
    let queue = OperationQueue()
    queue.maxConcurrentOperationCount = 6
    return queue
}()

let api = APIManager()
let reachability: Reachability = Reachability.forInternetConnection()

class APIManager {
    private let manager = SessionManager.default
    private let lock = NSLock()
    private var _taskCount = 0
    var log = true


    let validation: DataRequest.Validation = { ( request, result, data) -> DataRequest.ValidationResult in
        return Request.ValidationResult.success
    }

    let downloadValidation: DownloadRequest.Validation = { (request, response, temporaryURL, destinationURL)
        -> DownloadRequest.ValidationResult in
        return DownloadRequest.ValidationResult.success
    }

    let uploadValidation: UploadRequest.Validation = { (request, response, data)
        -> UploadRequest.ValidationResult in
        return UploadRequest.ValidationResult.success
    }


    var taskCount: Int {
        set {
            lock.sync {
                let oldValue = self.taskCount
                _taskCount = newValue
                if oldValue == 0 || newValue == 0 {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = newValue > 0
                }
            }
        }

        get {
            return _taskCount
        }
    }

    init() {

    }

    func logout() {
        manager.session.cancelAllTasks(completion: nil)
        backgroundQueue.cancelAllOperations()
    }

    func reset() {
        manager.session.cancelAllTasks(completion: nil)
        backgroundQueue.cancelAllOperations()
    }

    func request(input: BaseInputProtocol,
                 completion: @escaping ServiceCompletion) -> DataRequest {
        let encode: URLEncoding = input.method == .get ? .queryString : .default
        taskCount += 1
        let request = Alamofire.request(input.url,
                                        method: input.method,
                                        parameters: input.parameter,
                                        encoding: encode,
                                        headers: input.header)
        request.validate(validation)
        request.response(completion: completion)
        logRequest(input: input)
        return request
    }

    func download(path: URLConvertible,
                  progress: ((_ progress: Float) -> Void)?,
                  completion: @escaping (_ filePath: URL?, _ error: Error?, _ info: String?) -> Void) -> Request {

        var filePath: URL!
        taskCount += 1
        let request = Alamofire.download(path) { (url, response) -> (destinationURL: URL, options: DownloadRequest.DownloadOptions) in
            let link = NSTemporaryDirectory() + url.lastPathComponent
            filePath = URL(fileURLWithPath: link)
            return (filePath, DownloadRequest.DownloadOptions())
        }

        request.downloadProgress { (pro) in
            if let progress = progress {
                DispatchQueue.main.async {
                    progress(Float(pro.completedUnitCount) / Float(pro.totalUnitCount))
                }

            }
            }.validate(downloadValidation).responseJSON { (downloadRespone) in
                self.taskCount -= 1
                switch downloadRespone.result {
                case .success( _):
                    DispatchQueue.main.async {
                        completion(filePath, nil, nil)
                    }

                case .failure(let error):
                    DispatchQueue.main.async {
                        completion(nil, error, nil)
                    }
                }
        }
        return request

    }


    func upload(path: URLConvertible,
                data: Data,
                name: String,
                parameter: Parameter? = nil,
                headers: Header? = nil,
                progress: ((_ progress: Float) -> Void)?,
                completion: @escaping (_ error: Error?, _ info: String?) -> Void) {

        taskCount += 1

        Alamofire.upload(multipartFormData: { (multiData: MultipartFormData) in
            multiData.append(data, withName: "image")
            if let parameter = parameter {
                parameter.keys.forEach({ (key) in
                    if let data = (parameter[key] as AnyObject).data(using:  String.Encoding.utf8.rawValue) {
                        multiData.append(data, withName: key)
                    }
                })
            }

        }, usingThreshold: SessionManager.multipartFormDataEncodingMemoryThreshold ,
           to: path,
           method: .post,
           headers: headers) { (result) in
            switch result {
            case .success(let upload, _ , _):
                upload.validate(self.uploadValidation)

                upload.uploadProgress(closure: { (pro) in
                    if let progress = progress {
                        DispatchQueue.main.async {
                            progress(Float(pro.completedUnitCount) / Float(pro.totalUnitCount))
                        }
                    }
                })

                upload.responseJSON { response in
                    self.taskCount -= 1
                    switch response.result {
                    case .success( _):
                        DispatchQueue.main.async {
                            completion(nil, "Success")
                        }

                    case .failure(let error):
                        DispatchQueue.main.async {
                            completion(error, nil)
                        }

                    }

                }
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(error, nil)
                }
            }
        }

    }

    func logRequest(input: BaseInputProtocol) {
        if log {
            print("\n---------------REQUEST---------------")
            print("✎ URL: \(input.url)")
            print("✎ Method: \(input.method)")
            print("✎ Header: \(input.header!)")
            print("✎ Parameter: \(input.parameter!)")
            print("-------------------------------------\n")
        }
    }

    func logResponse(stype: ResponseStyle, response: HTTPURLResponse?, value: Any?, error: APIError?, timimg: TimeInterval) {
        if log {
            print("---------------RESPONSE--------------")
            let time = String.init(format: "%0.2fs", timimg)
            print(stype == .success ? "😍 SUCCESS (\(time))" : "😭 ERROR (\(time))")
            if let response = response {
                print("✎ URL: \(response.url!)")
                print("✎ Status code: \(response.statusCode)")
                print("✎ Header: \(response.allHeaderFields)")
            }
            if stype == .success {
                print("✎ Body: \(value!)")
            } else {
                print("✎ Error: \(error!.message)")
            }
            print("------------------------------------")
        }
    }

}

// MARK: - URLSession
extension URLSession {
    func cancelAllTasks(completion: (() -> Void)?) {
        getTasksWithCompletionHandler { (tasks, uploads, downloads) in
            for task in tasks {
                task.cancel()
            }
            for task in uploads {
                task.cancel()
            }
            for task in downloads {
                task.cancel()
            }
            completion?()
        }
    }
}

