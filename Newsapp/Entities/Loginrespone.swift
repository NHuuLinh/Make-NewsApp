//
//  LoginResponse.swift
//  Newsapp
//
//  Created by LinhMAC on 26/08/2023.
//
import Foundation
import ObjectMapper

struct LoginResponse: Decodable {
    var userId: String?
    var accessToken: String?
    var refreshToken: String?
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
    }
}

class LoginResponseByManual {
    var userId: String?
    var accessToken: String?
    var refreshToken: String?
    
    init(userId: String? = nil,
         accessToken: String? = nil,
         refreshToken: String? = nil) {
        self.userId = userId
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
}

class LoginResponseByObjectMapper: Mappable {
    var userId: String?
    var accessToken: String?
    var refreshToken: String?

    required init?(map: Map) {
    }

    // Mappable
    func mapping(map: Map) {
        userId <- map["user_id"]
        accessToken <- map["access_token"]
        refreshToken <- map["refresh_token"]
    }
}
