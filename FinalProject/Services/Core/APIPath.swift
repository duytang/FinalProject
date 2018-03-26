//
//  APIPath.swift
//  Wellmeshi
//
//  Created by PhuongVNC on 11/15/16.
//  Copyright © 2016 Vo Nguyen Chi Phuong. All rights reserved.
//

import Foundation
import Alamofire

class APIPath {
    static var EndPoint = "http://ec2-34-208-172-69.us-west-2.compute.amazonaws.com"
    static var EndVersion = "/api/v1/"

    struct Login {
        static var path: String { return EndPoint + EndVersion }
        static var login: String { return path + "auths" }
        static var forgot: String { return path + "forgot_passwords" }
        static var logout: String { return path + "query" }
        var URLString: String { return Login.path }
    }

}
