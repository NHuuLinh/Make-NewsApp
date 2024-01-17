//
//  ForgotPasswordViewController.swift
//  Newsapp
//
//  Created by LinhMAC on 22/08/2023.
//

import UIKit

class ForgotPasswordViewController: UIViewController {
    var email : String?

    @IBOutlet weak var emailLabel: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: true)
        // Do any additional setup after loading the view.
    }
    @IBAction func backButton(_ sender: Any) {
    }
    
    @IBAction func nextButton(_ sender: Any) {
        let storybroad = UIStoryboard(name: "Main", bundle: nil)
        let forgotEmail = storybroad.instantiateViewController(withIdentifier: "ValidEmailViewController") as! ValidEmailViewController
        forgotEmail.email = "Linh123"
//       navigationController?.popToRootViewController(animated: true)
        navigationController?.pushViewController(forgotEmail, animated: true)
    }

}
