//
//  LoginSocialPresenter.swift
//  Newsapp
//
//  Created by LinhMAC on 09/09/2023.
//

import Foundation

protocol LoginSocialPresenter {
    func loginByGoogle()
    func loginByTwitter()
    func loginByApple()
    func loginByFacebook()
}

/// Xử lý các logic liên quan đến login bằng mạng xã hội
class LoginSocialPresenterImpl: LoginSocialPresenter {
    var viewcontroller: LoginViewControllerSocialDisplay
    
    init(viewcontroller: LoginViewControllerSocialDisplay) {
        self.viewcontroller = viewcontroller
    }
    
    func loginByGoogle() {
        
    }
    
    func loginByTwitter() {
        
    }
    
    func loginByApple() {
        
    }
    
    func loginByFacebook() {
        
    }
}
