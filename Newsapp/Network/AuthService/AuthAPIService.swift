//
//  AuthAPIService.swift
//  Newsapp
//
//  Created by LinhMAC on 14/09/2023.
//

import Foundation
import Alamofire

protocol AuthAPIService {
    func login(email: String,
               password: String,
               success: ((LoginResponse) -> Void)?,
               failure: ((APIError?) -> Void)?)

    func register(name: String,
                  email: String,
                  password: String,
                  success: ((LoginResponse) -> Void)?,
                  failure: ((APIError?) -> Void)?)

    func logout(success: ((LoginResponse) -> Void)?,
                failure: ((APIError?) -> Void)?)
}

class AuthAPIServiceImpl: AuthAPIService {
    func login(email: String,
               password: String,
               success: ((LoginResponse) -> Void)?,
               failure: ((APIError?) -> Void)?) {
        let router = AuthRouter.login(body: [
            "email": email,
            "password": password
        ])
        AF.request(router)
            .cURLDescription { description in
                print(description)
            }
            .validate(statusCode: 200..<300)
            .responseDecodable(of: LoginResponse.self) { response in
            switch response.result {
            case .success(let entity):
                success?(entity)
            case .failure(let afError):
                failure?(APIError.from(afError: afError))
            }
        }
    }

    func register(name: String,
                  email: String,
                  password: String,
                  success: ((LoginResponse) -> Void)?,
                  failure: ((APIError?) -> Void)?) {
        let router = AuthRouter.register(body:[
            "name" : name,
            "email" : email,
            "password" : password
        ])
        AF.request(router)
            .cURLDescription{ description in
            print(description)
        }
            .validate(statusCode: 200..<300)
            .responseDecodable(of: LoginResponse.self) { response in
                switch response.result {
                case.success(let entity):
                    success?(entity)
                case.failure(let afError):
                    failure?(APIError.from(afError: afError))
                }
            }
    }

    func logout(success: ((LoginResponse) -> Void)?, failure: ((APIError?) -> Void)?) {

    }
}

