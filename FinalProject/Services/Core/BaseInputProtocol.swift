//
//  BaseInput.swift
//  Blank Project
//
//  Created by framgia on 5/30/17.
//  Copyright © 2017 Vo Nguyen Chi Phuong. All rights reserved.
//

import Foundation
import Alamofire

protocol BaseInputProtocol: class {
    var url: URLConvertible { get set }
    var header: Header? { get set }
    var parameter: Parameter? { get set }
    var method: HTTPMethod { get set }
    var useAccessToken: Bool { get set }
}

class BaseInput: BaseInputProtocol {
    var url: URLConvertible = APIPath.EndPoint
    var header: Header? = ["Content-Type": "application/x-www-form-urlencoded"]
    var parameter: Parameter?
    var method: HTTPMethod = .get
    var useAccessToken: Bool = true

    init() {}
}
