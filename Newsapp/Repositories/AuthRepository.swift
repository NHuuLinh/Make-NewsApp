//
//  AuthRepository.swift
//  Newsapp
//
//  Created by LinhMAC on 14/09/2023.
//

import Foundation

protocol AuthRepository {
    func login(email: String, password: String,
               success: ((LoginResponse) -> Void)?,
               failure: ((APIError?) -> Void)?)

    func register(nickname: String,
                  email: String,
                  password: String,
                  success: ((LoginResponse) -> Void)?,
                  failure: ((APIError?) -> Void)?)

    func logout(success: ((LoginResponse) -> Void)?,
                failure: ((APIError?) -> Void)?)
}

class AuthRepositoryImpl: AuthRepository {
    var authService: AuthAPIService

    init(authService: AuthAPIService) {
        self.authService = authService
    }

    func login(email: String, password: String, success: ((LoginResponse) -> Void)?, failure: ((APIError?) -> Void)?) {
        authService.login(email: email, password: password, success: success, failure: failure)
    }

    func register(nickname: String, email: String, password: String, success: ((LoginResponse) -> Void)?, failure: ((APIError?) -> Void)?) {
        authService.register(name: nickname, email: email, password: password, success: success, failure: failure)

    }

    func logout(success: ((LoginResponse) -> Void)?, failure: ((APIError?) -> Void)?) {

    }
}
