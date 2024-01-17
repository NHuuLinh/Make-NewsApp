//
//  OnBroad.swift
//  Newsapp
//
//  Created by LinhMAC on 24/08/2023.
//

import Foundation
import KeychainSwift
class Onbroad {
    static var shared = Onbroad()
    
    private init() {
        print("OnboardService 1")
    }
    enum Keys: String {
        case keyOnbroad
    }
    func markOnboarded() {
        let userDefault = UserDefaults.standard
        userDefault.setValue(true, forKey: Keys.keyOnbroad.rawValue)
    }
    
    func isOnboarded() -> Bool {
        let userDefault = UserDefaults.standard
        return userDefault.bool(forKey: Keys.keyOnbroad.rawValue)
    }
    
}
