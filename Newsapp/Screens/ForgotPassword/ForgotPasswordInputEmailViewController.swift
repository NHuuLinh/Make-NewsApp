//
//  RegisterViewController.swift
//  Newsapp
//
//  Created by LinhMAC on 24/08/2023.
//

import UIKit

class ForgotPasswordInputEmailViewController: UIViewController {


    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func handleBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func handleNext(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Forgot", bundle: nil)

        let forgotVerifyOTPVC = storyboard.instantiateViewController(withIdentifier:
                                                                        
        "ForgotPasswordVerifyOTPViewController") as! ForgotPasswordVerifyOTPViewController
         
        forgotVerifyOTPVC.email = "Linh@123@gmail.com"
        
        
        navigationController?.pushViewController(forgotVerifyOTPVC, animated: true)
    }

}
