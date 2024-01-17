//
//  RegisterPresenter.swift
//  Newsapp
//
//  Created by LinhMAC on 17/09/2023.
//

import Foundation
import Alamofire
protocol RegisterPresenter {
    func validateForm(email: String, password: String) -> Bool
    func register(email: String, password: String)
}

class RegisterPresenterImpl: RegisterPresenter {
    var authRepository : AuthRepository
    var registerVC : RegisterViewControllerDisplay
    init(authRepository: AuthRepository, RegisterVC: RegisterViewController) {
        self.authRepository = authRepository
        self.registerVC = RegisterVC
    }
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: email)
    }
    /**
     Cần 1 trạng thái là pass validate hay không? -> Bool
     */
    func validateForm(email: String, password: String) -> Bool {
        var isEmailValid = false
        var emailErrorMsg: String?
        
        if email.isEmpty {
            emailErrorMsg = "Email can't empty"
        }
        else if (!isValidEmail(email)) {
            emailErrorMsg = "Email invalid"
        }
        else {
            emailErrorMsg = nil
            isEmailValid = true
        }
        registerVC.registerValidateFailure(field: .email, message: emailErrorMsg)
        var isPasswordValid = false
        if password.isEmpty {
            registerVC.registerValidateFailure(field: .password,
                                         message: "Password can't empty")
        }
        else if password.count < 6 {
            registerVC.registerValidateFailure(field: .password,
                                         message: "Password must be at least 6 characters long.")
        }
        else {
            registerVC.registerValidateFailure(field: .password, message: nil)
            isPasswordValid = true
        }
        let isValid = isEmailValid && isPasswordValid
        return isValid
    }
    /// Viết logic xử lý login ở đây
    func register(email: String, password: String) {
//        // Validate trước khi call API
//        let isValid = validateForm(email: email, password: password)
//        guard isValid else {
//            /// Không pass validate thì không làm gì cả.
//            return
//        }
//        // CAll API ở đây
//        registerVC.showLoading(isShow: true)
//        authRepository.login(email: email, password: password) { [weak self] loginEntity in
//            guard let self = self else { return }
//            self.registerVC.showLoading(isShow: false)
//            if let accessToken = loginEntity.accessToken, !accessToken.isEmpty {
//                AuthService.share.accessToken = accessToken
//                print("accesstoken :", accessToken)
////                self.loginVC.loginSuccess(message: "success")
////                self.loginVC.gettoMainViewController()
//            } else {
//                print("error else")
////                self.loginVC.loginFailure(message: "something went wrong")
//            }
//        } failure: { [weak self] apiError in
//            guard let self = self else { return }
////            self.loginVC.showLoading(isShow: false)
////            self.loginVC.loginFailure(message: apiError?.errorMsg ?? "Something went wrong")
//            print("failure")
//            print(apiError ?? "")
//        }
    }
    
}


