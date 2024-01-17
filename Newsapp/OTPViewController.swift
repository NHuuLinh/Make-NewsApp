//
//  OTPViewController.swift
//  Newsapp
//
//  Created by LinhMAC on 22/08/2023.
//

import UIKit

class OTPViewController: UIViewController {
    var email : String?
    override func viewDidLoad() {
        super.viewDidLoad()
        var otpCodes = ["", "", "", "", "", ""]

        // Do any additional setup after loading the view.
    }
    @IBAction func backButton(_ sender: Any) {
    }
    
    @IBAction func nextButton(_ sender: Any) {
        let storybroad = UIStoryboard(name: "Main", bundle: nil)
        let forgotEmailVC = storybroad.instantiateViewController(withIdentifier: "ChangePasswordViewController") as! ChangePasswordViewController
//        navigationController?.popToRootViewController(animated: true)
        navigationController?.pushViewController(forgotEmailVC, animated: true)
    }
}
