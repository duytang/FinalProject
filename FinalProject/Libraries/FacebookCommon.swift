//
//  FacebookCommon.swift
//  Blank Project
//
//  Created by framgia on 6/5/17.
//  Copyright © 2017 Vo Nguyen Chi Phuong. All rights reserved.
//

//import Foundation
//import FacebookCore
//import FacebookLogin
//import FBSDKCoreKit
//
//enum LoginStatus {
//    case success(String)
//    case failure(Error)
//}
//
//class FacebookUser {
//    var userId = ""
//    var email = ""
//    var fullName = ""
//    var firstName = ""
//    var lastName = ""
//    var gender = ""
//    var avatar = ""
//    var accessToken = ""
//
//    init(json: [String: String]) {
//        userId = json["id"] ?? ""
//        email = json["email"] ?? ""
//        fullName = json["name"] ?? ""
//        firstName = json["first_name"] ?? ""
//        lastName = json["last_name"] ?? ""
//        gender = json["gender"] ?? ""
//        avatar = "https://graph.facebook.com/\(userId)/picture?height=320&type=normal&width=320"
//    }
//}
//
//
//typealias FBLoginCompletion = (LoginStatus) -> Void
//
//class FacebookCommon {
//    static let share = CPFacebookCommon()
//    private let loginManager = LoginManager()
//    private let permission: [ReadPermission] = [.email, .publicProfile]
//    private var graphParameter: [String: Any] {
//
//        let values: [String] = ["id,name,email"]
//        let key = "fields"
//        return [key: values]
//    }
//
//    func loginFacebook(completion: @escaping FBLoginCompletion) {
//        UserProfile.updatesOnAccessTokenChange = true
//        loginManager.logOut()
//        loginManager.logIn(permission, viewController: nil) { (loginResult) in
//            switch loginResult {
//            case .failed(let error):
//                completion(LoginStatus.failure(error))
//                break
//            case .cancelled:
//                break
//            case .success( _, _, let accessToken):
//                completion(LoginStatus.success(accessToken))
//                break
//            }
//        }
//    }
//}
