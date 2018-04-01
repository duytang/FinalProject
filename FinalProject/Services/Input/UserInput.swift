////
////  LoginInput.swift
////  WinWin Manager
////
////  Created by admin on 11/16/17.
////  Copyright © 2017 admin. All rights reserved.
////
//
//import Foundation
//
//class LoginInput: BaseInput {
//    init(id: String, password: String) {
//        super.init()
//        self.url = APIPath.API.login
//        self.method = .get
//        self.useAccessToken = false
//        let brower = AppDefine.nameDevice + "-" + AppDefine.idDevice
//        self.parameter = ["Browser": brower, "UserName": id,
//                          "PassWord": password, "IP": AppDefine.ip,
//                          "Code" : AppDefine.appCode]
//    }
//}
//
//class IPInput: BaseInput {
//    init(url: String) {
//        super.init()
//        self.header = nil
//        self.url = url
//        self.method = .get
//        self.useAccessToken = false
//    }
//}
//
//class RateInput: BaseInput {
//    init(url: String) {
//        super.init()
//        self.header = nil
//        self.url = url
//        self.method = .get
//        self.useAccessToken = false
//    }
//}
//
//class CurrentValueInput: BaseInput {
//    init(url: String) {
//        super.init()
//        self.header = nil
//        self.url = url
//        self.method = .get
//        self.useAccessToken = false
//    }
//}
//
//class FeeInput: BaseInput {
//    init(url: String) {
//        super.init()
//        self.header = nil
//        self.url = url
//        self.method = .get
//        self.useAccessToken = false
//    }
//}
//
//class RegisterInput: BaseInput {
//    init(email: String, password: String) {
//        super.init()
//        self.url = APIPath.API.register
//        self.method = .get
//        self.useAccessToken = false
//        self.parameter = ["Email": email, "PassWord": password,
//                          "Code" : AppDefine.appCode]
//    }
//}
//
//class ForgotPasswordInput: BaseInput {
//    init(idUser: String, email: String) {
//        super.init()
//        self.url = APIPath.API.forgotPassword
//        self.method = .get
//        self.useAccessToken = false
//        self.parameter = ["UserName": idUser, "Email": email,
//                          "Code" : AppDefine.appCode]
//    }
//}
//
//class ChangePasswordInput: BaseInput {
//    init(oldPass: String, newPass: String) {
//        super.init()
//        self.url = APIPath.API.changePassword
//        self.method = .get
//        self.useAccessToken = false
//        self.parameter = ["PassOld": oldPass, "PassNews": newPass,
//                          "Code" : AppManager.shared.userCode, "IP" : AppManager.shared.ip,
//                          "Browser" : AppDefine.nameDevice + "-" + AppDefine.idDevice]
//    }
//}
//
//class ChangePinCodeInput: BaseInput {
//    init(oldPin: String, newPin: String) {
//        super.init()
//        self.url = APIPath.API.changePincode
//        self.method = .get
//        self.useAccessToken = false
//        self.parameter = ["PinCodeOld": oldPin, "PinCodeNew": newPin,
//                          "Code" : AppManager.shared.userCode, "IP" : AppManager.shared.ip,
//                          "Browser" : AppDefine.nameDevice + "-" + AppDefine.idDevice]
//    }
//}
