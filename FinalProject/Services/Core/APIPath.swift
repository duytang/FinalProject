//
//  APIPath.swift
//  Base Project
//
//  Created by admin on 11/15/16.
//  Copyright © 2016 admin. All rights reserved.
//

import Foundation
import Alamofire

class APIPath {
    static var EndPoint = "https://www.googleapis.com/youtube/v3/"

    struct API {
        static var path: String { return EndPoint }

        static var category: String { return path + "videoCategories" }
        static var videos: String { return path + "videos" }
        static var channels: String { return path + "channels" }
    }
}
