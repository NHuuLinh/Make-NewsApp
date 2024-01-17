//
//  NetworkConstant.swift
//  Newsapp
//
//  Created by LinhMAC on 14/09/2023.
//

import Foundation
import Alamofire

class NetworkConstant {
    static var domain: String = "http://ec2-52-195-148-148.ap-northeast-1.compute.amazonaws.com"
}

struct APIError {
    var errorCode: String?
    var errorMsg: String?
    var errorKey: String?

    static func from(afError: AFError) -> APIError {
        return APIError(errorMsg: afError.errorDescription)
    }
}
