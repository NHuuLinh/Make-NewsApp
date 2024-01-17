//
//  RegisterViewController.swift
//  Newsapp
//
//  Created by LinhMAC on 24/08/2023.
//

import UIKit

/// Xử lý xóa
class OTPTextField: UITextField {
    var onDeleteBackward: (() -> Void)?
    
    override func deleteBackward() {
        if (self.text ?? "").isEmpty {
            onDeleteBackward?()
        }
        super.deleteBackward()
    }
}


// Màn B
class ForgotPasswordVerifyOTPViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak private var errorView: UIView!
    @IBOutlet weak private var messageLb: UILabel!
    @IBOutlet weak private var otpVerifyCountdownLb: UILabel!
    @IBOutlet weak var otpCode1: OTPTextField!
    @IBOutlet weak var otpCode2: OTPTextField!
    @IBOutlet weak var otpCode3: OTPTextField!
    @IBOutlet weak var otpCode4: OTPTextField!
    @IBOutlet weak var otpCode5: OTPTextField!
    @IBOutlet weak var otpCode6: OTPTextField!
    @IBOutlet weak private var verifyBtn: UIButton!
    
    var email: String?
    var errorColor = UIColor(red: 0.76, green: 0, blue: 0.32, alpha: 1)
    
    private var otpCodes = ["", "", "", "", "", ""]
    
    private var otpCodeTfs = [OTPTextField]()
    
    private var isValidOTP: Bool = false {
        didSet {
            errorView.isHidden = isValidOTP
            if isValidOTP {
                otpCodeTfs.forEach { otpTF in
                    otpTF.layer.borderWidth = 1
                    otpTF.layer.borderColor = UIColor(red: 0.31, green: 0.29, blue: 0.40, alpha: 1.00).cgColor
                    otpTF.backgroundColor = .white
                }
            } else {
                otpCodeTfs.forEach { otpTF in
                    otpTF.layer.borderWidth = 1
                    otpTF.layer.borderColor = UIColor(red: 0.76, green: 0, blue: 0.32, alpha: 1).cgColor
                    
                    otpTF.backgroundColor = UIColor(red: 1, green: 0.95, blue: 0.97, alpha: 1)
                }
            }
        }
    }
    
    private var maximumCountdownTime = 10 // 60 giây
    private var countCountdownTime = 10 // 60 giây
    private var countdownTimer: Timer?
    
    private var isExpiredOTPCode: Bool! {
        didSet {
            verifyBtn.isEnabled = !isExpiredOTPCode
            
            if isExpiredOTPCode {
                verifyBtn.backgroundColor = UIColor(red: 0.63, green: 0.64, blue: 0.74, alpha: 1.00)
            } else {
                verifyBtn.backgroundColor = UIColor(red: 0.09, green: 0.47, blue: 0.95, alpha: 1.00)
                
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        otpCodeTfs = [otpCode1, otpCode2, otpCode3, otpCode4, otpCode5, otpCode6]
        
        isValidOTP = true
        isExpiredOTPCode = false
        
        messageLb.text = String(format: "Enter the OTP sent to %@", email ?? "")
        
        otpCodeTfs.forEach { otpTF in
            otpTF.text = nil
            otpTF.delegate = self
            otpTF.keyboardType = .numberPad
            otpTF.onDeleteBackward = {
                self.prevOTPTextfieldFocus(textfield: otpTF)
            }
        }
        otpCode1.becomeFirstResponder()
        startCountdownTimer()
        otpVerifyCountdownLb.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(resendCodeAgain))
        otpVerifyCountdownLb.addGestureRecognizer(tapGesture)
    }
    
    @objc func resendCodeAgain() {
        if countCountdownTime == 0 {
            countCountdownTime = maximumCountdownTime
            startCountdownTimer()
            otpCodeTfs.forEach { otpTF in
                otpTF.text = nil
            }
            otpCode1.becomeFirstResponder()
            isExpiredOTPCode = false
            otpCodes = ["", "", "", "", "", ""]
        } else {
            print("CLick số")
        }
    }
    
    @IBAction func handleTextChange(_ sender: UITextField) {
        let text = sender.text ?? ""
        
        isValidOTP = true
        
        switch sender {
        case otpCode1:
            otpCodes[0] = text
            if text.count == 1 {
                otpCode2.becomeFirstResponder()
            }
        case otpCode2:
            otpCodes[1] = text
            if text.count == 1 {
                otpCode3.becomeFirstResponder()
            }
        case otpCode3:
            otpCodes[2] = text
            if text.count == 1 {
                otpCode4.becomeFirstResponder()
            }
        case otpCode4:
            otpCodes[3] = text
            if text.count == 1 {
                otpCode5.becomeFirstResponder()
            }
        case otpCode5:
            otpCodes[4] = text
            if text.count == 1 {
                otpCode6.becomeFirstResponder()
            }
        case otpCode6:
            otpCodes[5] = text
            if text.count == 1 {
                view.endEditing(true)
            }
        default:
            break;
        }
    }
    
    private func prevOTPTextfieldFocus(textfield: OTPTextField) {
        switch textfield {
        case self.otpCode6:
            self.otpCode5.becomeFirstResponder()
        case self.otpCode5:
            self.otpCode4.becomeFirstResponder()
        case self.otpCode4:
            self.otpCode3.becomeFirstResponder()
        case self.otpCode3:
            self.otpCode2.becomeFirstResponder()
        case self.otpCode2:
            self.otpCode1.becomeFirstResponder()
        default:
            break
        }
    }
    
    @IBAction func handleBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func handleNext(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Forgot", bundle: nil)
        
        /// Đối tượng của màn hình C
        let forgotChangePasswordVC = storyboard.instantiateViewController(withIdentifier: "ForgotPasswordChangePasswordViewController") as! ForgotPasswordChangePasswordViewController
        
        var isValid = true
        /// Validate otpcodes
        otpCodes.forEach { otpCode in
            if otpCode.isEmpty {
                isValid = false
            }
        }
        
        isValidOTP = isValid
        
        if isValid {
            /// Chuyển từ mảng otp code sang string
            let otpCode = otpCodes.joined()
            forgotChangePasswordVC.email = email
            forgotChangePasswordVC.otpCode = otpCode /// Mn xử lý lấy từ input textfield
            
            navigationController?.pushViewController(forgotChangePasswordVC, animated: true)
        }
    }
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        let text = textField.text ?? ""
        let isDelete = string == ""
        if text.count == 1 && !isDelete {
            return false
        }
        return true
    }
    
    private func startCountdownTimer() {
        if countdownTimer != nil && countdownTimer!.isValid {
            countdownTimer?.invalidate()
        }

        self.otpVerifyCountdownLb.text = "\(self.countCountdownTime)s"
        countdownTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            self.countCountdownTime -= 1
            
            if self.countCountdownTime == 0 {
                timer.invalidate()
                self.countdownTimer = nil
                self.isExpiredOTPCode = true
                self.otpVerifyCountdownLb.text = "Gửi lại"
            } else {
                self.otpVerifyCountdownLb.text = "\(self.countCountdownTime)s"
            }
        }
    }
}
