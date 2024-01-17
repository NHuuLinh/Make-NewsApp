//
//  RegisterViewController.swift
//  Newsapp
//
//  Created by LinhMAC on 24/08/2023.
//

import UIKit

class ForgotPasswordChangePasswordViewController: UIViewController {

    var email: String?
    var otpCode: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func handleBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func handleNext(_ sender: Any) {
        callAPIResetPassword()
    }
    private func callAPIResetPassword() {
        print("Call api \(email ?? ""), otp là \(otpCode ?? "")")
        navigationController?.popToRootViewController(animated: true)
    }
}
