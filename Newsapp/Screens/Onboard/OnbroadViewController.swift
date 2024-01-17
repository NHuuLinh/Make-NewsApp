//
//  OnbroadViewController.swift
//  Newsapp
//
//  Created by LinhMAC on 26/08/2023.
//

import UIKit

class OnbroadViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func onhandeleOnbroad(_ sender: Any) {
        Onbroad.shared.markOnboarded()

        if let uwWindow = (UIApplication.shared.delegate as? AppDelegate)?.window {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
            let loginNavigation = UINavigationController(rootViewController: loginVC)
            uwWindow.rootViewController = loginNavigation
            uwWindow.makeKeyAndVisible()
        } else {
            print("error")
        }
    }
}
