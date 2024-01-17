//
//  ValidEmailViewController.swift
//  Newsapp
//
//  Created by LinhMAC on 22/08/2023.
//

import UIKit

class ValidEmailViewController: UIViewController {
    var email : String?

    @IBOutlet weak var emailTF: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTF.text = email
//        DisplayEmailOTPlb.text = String

        // Do any additional setup after loading the view.
    }
    @IBAction func backButton(_ sender: Any) {
        let forgetVC = storyboard?.instantiateViewController(identifier: "ForgotPasswordViewController") as! ForgotPasswordViewController
//        navigationController?.popViewController(forgetVC, animated: true)
    }
    
    @IBAction func nextButton(_ sender: Any) {
        let storybroad = UIStoryboard(name: "Main", bundle: nil)
        let forgotEmailVC = storybroad.instantiateViewController(withIdentifier: "OTPViewController") as! OTPViewController
//        forgotEmailVC.email = "1123"
//        navigationController?.popToRootViewController(animated: true)
        navigationController?.pushViewController(forgotEmailVC, animated: true)
    }
}
