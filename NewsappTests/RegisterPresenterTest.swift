//
//  RegisterPresenterTest.swift
//  NewsappTests
//
//  Created by LinhMAC on 24/01/2024.
//

import XCTest
@testable import Newsapp


final class RegisterPresenterTest: XCTestCase {
    class MockRegisterViewController: RegisterViewController {
        
    }
    class MockAuthRepository: AuthRepository{
        func login(email: String, password: String, success: ((Newsapp.LoginResponse) -> Void)?, failure: ((Newsapp.APIError?) -> Void)?) {
            
        }
        
        func register(nickname: String, email: String, password: String, success: ((Newsapp.LoginResponse) -> Void)?, failure: ((Newsapp.APIError?) -> Void)?) {
            
        }
        
        func logout(success: ((Newsapp.LoginResponse) -> Void)?, failure: ((Newsapp.APIError?) -> Void)?) {
            
        }
    }

    var presenter: RegisterPresenterImpl!
    var mockRegisterVC: MockRegisterViewController!
    var mockAuthRepository: AuthRepository!
        
        override func setUp() {
            super.setUp()
            mockRegisterVC = MockRegisterViewController()
            mockAuthRepository = MockAuthRepository()
            presenter = RegisterPresenterImpl(authRepository: mockAuthRepository, RegisterVC: mockRegisterVC)
        }
    func testEmailValidForm(){
        var isValid = presenter.emailValid(email: "linh@gmail.com").valid
        XCTAssertTrue(isValid)
    }
    func testEmailinValidForm(){
        var isValid = presenter.emailValid(email: "linh@").valid
        XCTAssertFalse(isValid)
    }
    func testPasswordinValid(){
        var isValid = presenter.passwordValid(password: "123").valid
        XCTAssertFalse(isValid)
    }
    func testPasswordValid(){
        var isValid = presenter.passwordValid(password: "123456").valid
        XCTAssertTrue(isValid)
    }
}
