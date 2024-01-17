//
//  AuthService.swift
//  Newsapp
//
//  Created by LinhMAC on 24/08/2023.
//

//import Foundation
//import KeychainSwift
//class AuthService {
//    static var shared = AuthService()
//    private init() {
//        print("")
//    }
//    enum Keys: String {
//        case keyAccessToken
//    }
//    func saveAccesToken(acessToken : String) {
//        let keychain = KeychainSwift()
//        keychain.set(acessToken, forKey: Keys.keyAccessToken.rawValue)
//
//    }
//    func getAccessToken() -> String? {
//        let keychain = KeychainSwift()
//        return keychain.get(Keys.keyAccessToken.rawValue)
//    }
//    func clearAccessToken() {
//        let keychain = KeychainSwift()
//        keychain.delete(Keys.keyAccessToken.rawValue)
//    }
//    var isLoggedIn: Bool {
//        let token = getAccessToken()
////        print("\(token)")
//        return token != nil && !(token!.isEmpty)
//    }
//
//}
import Foundation
import KeychainSwift

class AuthService {
    static var share = AuthService()
    private var keychain: KeychainSwift
    
    private enum Keys: String {
        case kAccessToken
        case kRefreshToken
    }
    
    private init() {
        keychain = KeychainSwift()
    }
    
    var accessToken: String {
        get {
            return keychain.get(Keys.kAccessToken.rawValue) ?? ""
        }
        set {
            if newValue.isEmpty {
                keychain.delete(Keys.kAccessToken.rawValue)
            } else {
                keychain.set(newValue, forKey: Keys.kAccessToken.rawValue)
            }
        }
    }
    
    var isLoggedIn: Bool {
        return !accessToken.isEmpty
    }
    
    func clearAll() {
        accessToken = ""
    }
}
