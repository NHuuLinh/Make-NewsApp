//
//  ChangePasswordViewController.swift
//  Newsapp
//
//  Created by LinhMAC on 22/08/2023.
//

import UIKit

class ChangePasswordViewController: UIViewController {
    var truyendulieu : String?

    override func viewDidLoad() {
        super.viewDidLoad()
        print("\(truyendulieu)")

        // Do any additional setup after loading the view.
    }
    @IBAction func backButton(_ sender: Any) {
    }
    
    @IBAction func nextButton(_ sender: Any) {
        let storybroad = UIStoryboard(name: "Main", bundle: nil)
        let forgotEmailVC = storybroad.instantiateViewController(withIdentifier: "ValidEmailViewController") as! ValidEmailViewController
        navigationController?.popToRootViewController(animated: true)
//        navigationController?.pushViewController(forgotEmailVC, animated: true)
    }

}
