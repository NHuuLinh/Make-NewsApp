
//  RegisterViewController.swift
//  Newsapp
//
//  Created by LinhMAC on 19/08/2023.
//

import UIKit
import Alamofire
import ObjectMapper
import MBProgressHUD

protocol RegisterViewControllerDisplay {
    func RegisterFailure(message: String)
    func showLoading(isShow: Bool)
    func emailValidColor()
    func passwordValidColor()
    func nameValidColor()
    func emailErrorColor()
    func passWordErrorColor()
    func nameErrorColor()
}
enum RegisterFormField {
    case email
    case password
}


class RegisterViewController: UIViewController, RegisterViewControllerDisplay {
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var emailerrorTF: UITextField!
    @IBOutlet weak var clearBtn: UIButton!
    @IBOutlet weak var passWordTF: UITextField!
    @IBOutlet weak var errorPW: UITextField!
    @IBOutlet weak var passworderrorIcon: UIImageView!
    @IBOutlet weak var nickNmaeTF: UITextField!
    @IBOutlet weak var emailTextView: UIView!
    @IBOutlet weak var errorViewHieght: NSLayoutConstraint!
    @IBOutlet weak var passwordErorrView: UIView!
    @IBOutlet weak var passwordTextView: UIView!
    @IBOutlet weak var passwordErrorViewHieght: NSLayoutConstraint!
    @IBOutlet weak var nameErorrView: UIView!
    @IBOutlet weak var nameTextView: UIView!
    @IBOutlet weak var nameErrorViewHieght: NSLayoutConstraint!
    @IBOutlet weak var nameErorText: UITextField!
    @IBOutlet weak var nameClearBtn: UIButton!
    private var registerPresenter: RegisterPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerPresenter = RegisterPresenterImpl(authRepository: AuthRepositoryImpl(authService: AuthAPIServiceImpl()), RegisterVC: self)
        emailTF.addTarget(self, action: #selector(emailTextFieldDidChange), for: .editingChanged)
        emailValidColor()
        passwordValidColor()
        nameValidColor()
    }
    func emailValidColor(){
        clearBtn.isHidden = true
        errorView.isHidden = true
        errorViewHieght.constant = 0
        emailTextView.layoutIfNeeded()
        emailTextView.layer.borderWidth = 2
        emailTextView.layer.cornerRadius = 6
        emailTextView.layer.borderColor = UIColor(red: 0.31, green: 0.29, blue: 0.4, alpha: 1).cgColor
    }
    func passwordValidColor(){
        passwordErorrView.isHidden = true
        passwordErrorViewHieght.constant = 0
        passwordErorrView.layoutIfNeeded()
        passwordTextView.layer.borderWidth = 2
        passwordTextView.layer.cornerRadius = 6
        passwordTextView.layer.borderColor = UIColor(red: 0.31, green: 0.29, blue: 0.4, alpha: 1).cgColor
    }
    func nameValidColor(){
        nameErorrView.isHidden = true
        nameTextView.backgroundColor = .clear
        nameErrorViewHieght.constant = 0
        nameErorrView.layer.borderWidth = 2
        nameErorrView.layer.cornerRadius = 6
        nameErorrView.layoutIfNeeded()

    }
    func emailErrorColor() {
        errorView.isHidden = false
        emailTextView.backgroundColor = UIColor(red: 1, green: 0.95, blue: 0.97, alpha: 1)
        errorViewHieght.constant = 21
        emailTextView.layoutIfNeeded()
    }
    func passWordErrorColor(){
        passwordErorrView.isHidden = false
        passwordErrorViewHieght.constant = 21
        passwordErorrView.layoutIfNeeded()
        passwordTextView.layer.borderWidth = 2
        passwordTextView.layer.cornerRadius = 6
        passwordTextView.backgroundColor = UIColor(red: 1, green: 0.95, blue: 0.97, alpha: 1)

    }
    func nameErrorColor(){
        nameErorrView.isHidden = false
        nameErorrView.layoutIfNeeded()
        nameErorrView.layer.borderWidth = 2
        nameErorrView.layer.cornerRadius = 6
        nameTextView.backgroundColor = UIColor(red: 1, green: 0.95, blue: 0.97, alpha: 1)
        nameErrorViewHieght.constant = 21
        nameErorrView.layoutIfNeeded()
    }

    func emailValid(email: String) -> (String){
        var emailErrorMsg = ""
        if email.isEmpty {
            emailErrorMsg = "Email can't empty"
            emailErrorColor()
            return emailErrorMsg
        }
        else if !registerPresenter.isValidEmail(email) {
            emailErrorMsg = "Email invalid"
            emailErrorColor()
            return emailErrorMsg
        }
        else {
            emailErrorMsg = ""
            emailValidColor()
            return emailErrorMsg
        }
    }
    func passwordValid(password: String) -> (String){
        var passwordErrorMsg = ""
        if password.isEmpty {
            passwordErrorMsg = "password can't empty"
            passWordErrorColor()
            return passwordErrorMsg
        } else if password.count < 6 {
            passwordErrorMsg = "password need more than 6 digit"
            passWordErrorColor()
            return passwordErrorMsg
        }
        else {
            passwordErrorMsg = ""
            passwordValidColor()
            return passwordErrorMsg
        }
    }
    func nameValid(name: String) -> (String){
        var passwordErrorMsg = ""
        if name.isEmpty {
            passwordErrorMsg = "password can't empty"
            nameErrorColor()
            return passwordErrorMsg
        } else if name.count < 6 {
            passwordErrorMsg = "password need more than 6 digit"
            nameErrorColor()
            return passwordErrorMsg
        }
        else {
            passwordErrorMsg = ""
            nameValidColor()
            return passwordErrorMsg
        }
    }
    @objc private func emailTextFieldDidChange() {
        if let emailText = emailTF.text, !emailText.isEmpty {
            clearBtn.isHidden = false
        } else {
            clearBtn.isHidden = true
        }
    }
    @objc private func nameTextFieldDidChange() {
        if let nameText = nickNmaeTF.text, !nameText.isEmpty {
            clearBtn.isHidden = false
        } else {
            clearBtn.isHidden = true
        }
    }
    
    @IBAction func inputĐiChanged(_ sender: Any) {
        let email = emailTF.text ?? ""
        let password = passWordTF.text ?? ""
        let name = nickNmaeTF.text ?? ""
        emailerrorTF.text = emailValid(email: email)
        errorPW.text = passwordValid(password: password)
        print("\(errorPW.text)")
        nameErorText.text = nameValid(name: name)
    }
    @IBAction func onClearButton(_ sender: Any) {
        emailTF.text = ""
        clearBtn.isHidden = true
    }
    
    @IBAction func nameClearButton(_ sender: Any) {
        nickNmaeTF.text = ""
        nameClearBtn.isHidden = true
    }

    @IBAction func onHandleButton(_ sender: Any) {
        errorView.isHidden = true
        clearBtn.isHidden = true
        let email = emailTF.text ?? ""
        let password = passWordTF.text ?? ""
        let name = nickNmaeTF.text ?? ""
        registerPresenter.register(email: email, password: password, name: name)
    }
    @IBAction func Loginbutton(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    @IBAction func HiddenButton(_ sender: Any) {
        passWordTF.isSecureTextEntry = !passWordTF.isSecureTextEntry
    }
    func RegisterFailure(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    func showLoading(isShow: Bool) {
        if isShow {
            MBProgressHUD.showAdded(to: self.view, animated: true)
        } else {
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
}

