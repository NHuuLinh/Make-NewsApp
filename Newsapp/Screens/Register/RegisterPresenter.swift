//
//  RegisterPresenter.swift
//  Newsapp
//
//  Created by LinhMAC on 17/09/2023.
//

import Foundation
import Alamofire
protocol RegisterPresenter {
    func register(email: String, password: String, name: String)
    func emailValid(email: String) -> (valid: Bool,message: String)
    func passwordValid(password: String) -> (valid: Bool,message: String)
    func nameValid(name: String) -> (valid: Bool,message: String)
    func isValidEmail(_ email: String) -> Bool
}

class RegisterPresenterImpl: RegisterPresenter {
    var authRepository : AuthRepository
    var registerVC : RegisterViewControllerDisplay
    init(authRepository: AuthRepository, RegisterVC: RegisterViewController) {
        self.authRepository = authRepository
        self.registerVC = RegisterVC
    }
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: email)
    }
    /**
     Cần 1 trạng thái là pass validate hay không? -> Bool
     */
    func emailValid(email: String) -> (valid: Bool,message: String){
        var emailErrorMsg = ""
        if email.isEmpty {
            emailErrorMsg = "Email can't empty"
//            registerVC.emailErrorColor()
            return (false,emailErrorMsg)
        }
        else if (!isValidEmail(email)) {
            emailErrorMsg = "Email invalid"
//            registerVC.emailErrorColor()
            return (false,emailErrorMsg)
        }
        else {
            emailErrorMsg = ""
//            registerVC.emailValidColor()
            return (true,emailErrorMsg)
        }
    }
    func passwordValid(password: String) -> (valid: Bool,message: String){
        var passwordErrorMsg = ""
        if password.isEmpty {
            passwordErrorMsg = "password can't empty"
//            registerVC.passWordErrorColor()
            return (false,passwordErrorMsg)
        } else if password.count < 6 {
            passwordErrorMsg = "password need more than 6 digit"
//            registerVC.passWordErrorColor()
            return (false,passwordErrorMsg)
        }
        else {
            passwordErrorMsg = ""
//            registerVC.passwordValidColor()
            return (true,passwordErrorMsg)
        }
    }
    func nameValid(name: String) -> (valid: Bool,message: String){
        var passwordErrorMsg = ""
        if name.isEmpty {
            passwordErrorMsg = "password can't empty"
            registerVC.passWordErrorColor()
            return (false,passwordErrorMsg)
        } else if name.count < 6 {
            passwordErrorMsg = "password need more than 6 digit"
            registerVC.passWordErrorColor()
            return (false,passwordErrorMsg)
        }
        else {
            passwordErrorMsg = ""
            registerVC.passwordValidColor()
            return (true,passwordErrorMsg)
        }
    }
    /// Viết logic xử lý login ở đây
    func register(email: String, password: String, name: String) {
        // Validate trước khi call API
        let emailValid = emailValid(email: email).valid
        let passwordValid = passwordValid(password: password).valid
        let nameValid = nameValid(name: name).valid
        guard emailValid && passwordValid && nameValid else {
            /// Không pass validate thì không làm gì cả.
            return
        }
        // CAll API ở đây
        registerVC.showLoading(isShow: true)
        authRepository.login(email: email, password: password) { [weak self] loginEntity in
            guard let self = self else { return }
            self.registerVC.showLoading(isShow: false)
            if let accessToken = loginEntity.accessToken, !accessToken.isEmpty {
                AuthService.share.accessToken = accessToken
                print("accesstoken :", accessToken)
            } else {
                print("error else")
                self.registerVC.RegisterFailure(message: "lỗi khi đăng kí tài khoản")
            }
        } failure: { [weak self] apiError in
            guard let self = self else { return }
            self.registerVC.showLoading(isShow: false)
            print("failure")
            print(apiError ?? "")
        }
    }
    
}


