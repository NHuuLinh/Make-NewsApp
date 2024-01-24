//
//  NewsappTests.swift
//  NewsappTests
//
//  Created by LinhMAC on 24/01/2024.
//

import XCTest
@testable import Newsapp

final class NewsappTests: XCTestCase {

    class MockLoginViewController: LoginViewControllerDisplay {
        func loginValidateFailure(field: Newsapp.LoginFormField, message: String?) {
            
        }
        
        var loginValidateFailureCalled = false
        var emailValidCalled = false
        var emailErrorColorCalled = false
        var passwordValidCalled = false
        var passWordErrorColorCalled = false
        var showLoadingCalled = false
        var loginSuccessCalled = false
        var loginFailureCalled = false

        func emailValid() {
            emailValidCalled = true
        }

        func emailErrorColor() {
            emailErrorColorCalled = true
        }

        func passwordValid() {
            passwordValidCalled = true
        }

        func passWordErrorColor() {
            passWordErrorColorCalled = true
        }

        func showLoading(isShow: Bool) {
            showLoadingCalled = true
        }

        func loginSuccess(message: String) {
            loginSuccessCalled = true
        }

        func loginFailure(message: String) {
            loginFailureCalled = true
        }
        
        func gettoMainViewController() {
            // Implement if needed
        }
    }

    var presenter: LoginPresenterImpl!
    var mockLoginVC: MockLoginViewController!
    var mockAuthRepository: AuthRepository!

    override func setUp() {
        super.setUp()
        mockLoginVC = MockLoginViewController()
        mockAuthRepository = MockAuthRepository()
        presenter = LoginPresenterImpl(loginVC: mockLoginVC, authRepository: mockAuthRepository)
    }

    func testValidateFormWithValidInput() {
        let isValid = presenter.validateForm(email: "test@example.com", password: "password123")
        XCTAssertTrue(isValid)
        XCTAssertTrue(mockLoginVC.emailValidCalled)
        XCTAssertTrue(mockLoginVC.passwordValidCalled)
        XCTAssertFalse(mockLoginVC.loginValidateFailureCalled)
        XCTAssertFalse(mockLoginVC.emailErrorColorCalled)
        XCTAssertFalse(mockLoginVC.passWordErrorColorCalled)
    }

    func testValidateFormWithInvalidEmail() {
        let isValid = presenter.validateForm(email: "invalidemail", password: "password123")
        XCTAssertFalse(isValid)
        XCTAssertTrue(mockLoginVC.loginValidateFailureCalled)
        XCTAssertTrue(mockLoginVC.emailErrorColorCalled)
        XCTAssertFalse(mockLoginVC.emailValidCalled)
        XCTAssertFalse(mockLoginVC.passwordValidCalled)
        XCTAssertFalse(mockLoginVC.passWordErrorColorCalled)
    }
    class MockAuthRepository: AuthRepository {
        func login(email: String, password: String, success: ((Newsapp.LoginResponse) -> Void)?, failure: ((Newsapp.APIError?) -> Void)?) {
            
        }
        
        func register(nickname: String, email: String, password: String, success: ((Newsapp.LoginResponse) -> Void)?, failure: ((Newsapp.APIError?) -> Void)?) {
            
        }
        
        func logout(success: ((Newsapp.LoginResponse) -> Void)?, failure: ((Newsapp.APIError?) -> Void)?) {
            
        }
        
    }
    

    func test(){
        let number = 3
        let number2 = 4
        let number3 = number + number2
        XCTAssertEqual(number3, 7)
    }


}
