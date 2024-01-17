
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
    func registerValidateFailure(field: RegisterFormField, message: String?)
    func showLoading(isShow: Bool)
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
        setupView()
        emailTF.addTarget(self, action: #selector(emailTextFieldDidChange), for: .editingChanged)
    }
    private func setupView(){
        clearBtn.isHidden = true
        errorView.isHidden = true
        errorViewHieght.constant = 0
        emailTextView.layoutIfNeeded()
        emailTextView.layer.borderWidth = 2
        emailTextView.layer.cornerRadius = 6
        emailTextView.layer.borderColor = UIColor(red: 0.31, green: 0.29, blue: 0.4, alpha: 1).cgColor
        
        passwordErorrView.isHidden = true
        passwordErrorViewHieght.constant = 0
        passwordErorrView.layoutIfNeeded()
        passwordTextView.layer.borderWidth = 2
        passwordTextView.layer.cornerRadius = 6
        passwordTextView.layer.borderColor = UIColor(red: 0.31, green: 0.29, blue: 0.4, alpha: 1).cgColor
        
        nameErorrView.isHidden = true
        nameErrorViewHieght.constant = 0
        nameErorrView.layoutIfNeeded()
        nameTextView.layer.borderWidth = 2
        nameTextView.layer.cornerRadius = 6
        nameTextView.layer.borderColor = UIColor(red: 0.31, green: 0.29, blue: 0.4, alpha: 1).cgColor
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
    @IBAction func onClearButton(_ sender: Any) {
        emailTF.text = ""
        clearBtn.isHidden = true
    }
    
    @IBAction func nameClearButton(_ sender: Any) {
        nickNmaeTF.text = ""
        nameClearBtn.isHidden = true
        
    }
    func emailErrorColor() {
        errorView.isHidden = false
        emailTextView.backgroundColor = UIColor(red: 1, green: 0.95, blue: 0.97, alpha: 1)
        errorViewHieght.constant = 21
        emailTextView.layoutIfNeeded()
    }
    func passWordErrorColor(){
        passwordErorrView.isHidden = false
        passwordErorrView.layoutIfNeeded()
        passwordTextView.backgroundColor = UIColor(red: 1, green: 0.95, blue: 0.97, alpha: 1)
        passwordErrorViewHieght.constant = 21
    }
    func registerValidateFailure(field: RegisterFormField, message: String?) {
        switch field {
        case .email:
            emailerrorTF.isHidden = false
            emailerrorTF.text = message
        case .password:
            errorPW.isHidden = false
            errorPW.text = message
        }
    }
    func onHandleValidateForm(email: String, password: String, name: String) -> Bool {
        var isEmailValid = false
        if email.isEmpty {
            emailerrorTF.text = "không thể để trống email"
            emailErrorColor()
        } else if (registerPresenter.validateForm(email: email, password: password)) {
            emailerrorTF.text = "email không hợp lệ"
            emailErrorColor()
        }
        else {
            isEmailValid = true
            errorView.isHidden = true
            emailTextView.backgroundColor = .clear
            errorViewHieght.constant = 0
            emailTextView.layoutIfNeeded()
        }
        var isPasswordValid = false
        if password.isEmpty {
            errorPW.text = "không thể để trống password"
            passWordErrorColor()
        }else if password.count < 6 {
            errorPW.text = "mật khẩu dài hơn 6 kí tự"
            passWordErrorColor()
        }else if password.count > 40 {
            errorPW.text = "mật khẩu không dài hơn 40 kí tự"
            passWordErrorColor()
        } else {
            passwordErorrView.isHidden = true
            passwordErorrView.layoutIfNeeded()
            passwordTextView.backgroundColor = .clear
            passwordErrorViewHieght.constant = 0
            isPasswordValid = true
        }
        
        var isNameValid = false
        if name.isEmpty {
            nameErorText.text = "không thể để trống tên"
            nameErorrView.isHidden = false
            nameErorrView.layoutIfNeeded()
            nameTextView.backgroundColor = UIColor(red: 1, green: 0.95, blue: 0.97, alpha: 1)
            nameErrorViewHieght.constant = 21
            nameErorrView.layoutIfNeeded()
        } else {
            nameErorrView.isHidden = true
            nameErorrView.layoutIfNeeded()
            nameTextView.backgroundColor = .clear
            nameErrorViewHieght.constant = 0
            isNameValid = true
        }
        let isValid = isEmailValid && isPasswordValid && isNameValid
        return isValid
    }
    @IBAction func onHandleButton(_ sender: Any) {
        errorView.isHidden = true
        clearBtn.isHidden = true
        let email = emailTF.text ?? "";
        let password = passWordTF.text ?? "";
        let name = nickNmaeTF.text ?? "";
        let isValid = onHandleValidateForm(email: email, password: password, name: name)
        guard isValid else {
            return
        }
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

