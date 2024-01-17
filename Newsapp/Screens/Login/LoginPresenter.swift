import Foundation
import Alamofire
/**
 Sừ dụng tính "Trìu tượng" Trong OOP
 */
protocol LoginPresenter {
    // Login
    func login(email: String, password: String)
    func validateForm(email: String, password: String) -> Bool
}
/**
 Viewcontroller: Xử lý cả logic và UI
 */
// =>
/**
 Mục đich: Tách biệt logic giữa Presenter và Viewcontroller
 Presenter: Xử lý logic
 ViewController: Xử lý UI
 Nhiệm vụ: Xử các business logic (logic)
 Không liên đến view (outlet*)
 */
/// Impl == Implement
class LoginPresenterImpl: LoginPresenter {
    var loginVC: LoginViewControllerDisplay // Liên kết đến LoginViewController
    var authRepository: AuthRepository

    init(loginVC: LoginViewControllerDisplay, authRepository: AuthRepository) {
        self.loginVC = loginVC
        self.authRepository = authRepository
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
//        var emailErrorMsg: String?
//        loginVC.loginValidateFailure(field: .email,
//                                     message: emailErrorMsg)
        if email.isEmpty {
//            emailErrorMsg = "Email can't empty"
            loginVC.loginValidateFailure(field: .email,
                                         message: "Email can't empty")
            loginVC.emailErrorColor()
        }
        else if (!isValidEmail(email)) {
//            emailErrorMsg = "Email invalid"
            loginVC.loginValidateFailure(field: .email,
                                         message: "Email invalid")
            loginVC.emailErrorColor()
        }
        else {
//            emailErrorMsg = nil
            isEmailValid = true
            loginVC.emailValid()
        }

        var isPasswordValid = false
        if password.isEmpty {
            loginVC.loginValidateFailure(field: .password,
                                         message: "Password can't empty")
            loginVC.passWordErrorColor()
        }
        else if password.count < 6 {
            loginVC.loginValidateFailure(field: .password,
                                         message: "Password must be at least 6 characters long.")
            loginVC.passWordErrorColor()
        }
        else {
            loginVC.loginValidateFailure(field: .password, message: nil)
            isPasswordValid = true
            loginVC.passwordValid()
        }
        let isValid = isEmailValid && isPasswordValid
        return isValid
    }
    /// Viết logic xử lý login ở đây
    func login(email: String, password: String) {
        // Validate trước khi call API
        let isValid = validateForm(email: email, password: password)
        guard isValid else {
            /// Không pass validate thì không làm gì cả.
            return
        }
        // CAll API ở đây
//        AF.request(URLConvertible)
        loginVC.showLoading(isShow: true)
        authRepository.login(email: email, password: password) { [weak self] loginEntity in
            guard let self = self else { return }
            self.loginVC.showLoading(isShow: false)
            if let accessToken = loginEntity.accessToken, !accessToken.isEmpty {
                AuthService.share.accessToken = accessToken
                print("accesstoken :", accessToken)
//                self.loginVC.loginSuccess(message: "success")
                self.loginVC.gettoMainViewController()
            } else {
                print("error else")
                self.loginVC.loginFailure(message: "something went wrong")
            }
        } failure: { [weak self] apiError in
            guard let self = self else { return }
            self.loginVC.showLoading(isShow: false)
            self.loginVC.loginFailure(message: apiError?.errorMsg ?? "Something went wrong")
            print("failure")
            print(apiError ?? "")
        }
    }
}
