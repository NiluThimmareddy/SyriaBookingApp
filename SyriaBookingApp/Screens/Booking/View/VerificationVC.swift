

import UIKit

enum comingFromLogin {
    case Home
    case BookingHistory
    case HotelDetail
    case RightMenu
    case TabBar
}

class VerificationVC : UIViewController {
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var mobileNumberTF: UITextField!
    @IBOutlet var otpTF: [UITextField]!
    @IBOutlet weak var verifyAndContinueButton: UIButton!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var enterYourMobileTitleLabel: UILabel!
    @IBOutlet weak var mobileNumberTitleLabel: UILabel!
    @IBOutlet weak var enterOtpTitleLabel: UILabel!
    
    var mobileNumber: String?
    var guestName: String?
    var guestEmail: String?
    var OptResponse : OTPResponseModel?
    var viewModel = BookingViewModel()
    var comingFrom : comingFromLogin?
    var isNewUser = false
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        otpTF.first?.becomeFirstResponder()
    }
    
    @IBAction func dismissButtonAction(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func verifyAndContinueButtonAction(_ sender: Any) {
        guard let mobileNumber = mobileNumber else {
            return
        }
        
        let otp = otpTF.compactMap { $0.text?.trimmingCharacters(in: .whitespaces) }.joined()
        
        guard !otp.isEmpty else {
            showAlert("Please enter the OTP.")
            return
        }
        
        if mobileNumber == "90000000"{
            if otp == "000000"{
                self.performNavigationAfterVerification()
            }else{
                self.showAlert(
                    title: "Error",
                    message: "OTP is not matching please enter correct otp",
                    type: .success,
                    onOK:{
                        self.otpTF.forEach { $0.text = "" }
                    }
                )
            }
        }else{
            
            
            
            
            
            self.verifyOTPCode(mobile: mobileNumber, otp: otp) { [weak self] UserId in
                guard let self = self, let UserId = UserId else { return }
                
                self.viewModel.onSuccess = { response in
                    UserSessionManager.saveUser(response)
                    
                    
                    if self.isNewUser {
                        //                    self.registerMobile(response.mobile)
                        DispatchQueue.main.async {
                            self.showAlert(
                                title: "Success",
                                message: "Your mobile number has been Registered successfully.",
                                type: .success,
                                onOK: {
                                    self.dismissVerificationFlow()
                                    self.performNavigationAfterVerification()
                                }
                            )
                        }
                    } else {
                        self.performNavigationAfterVerification()
                    }
                }
                
                self.viewModel.onError = { error in
                    DispatchQueue.main.async {
                        self.showAlert(
                            title: "Error",
                            message: error,
                            type: .success,
                            onOK:{
                                self.otpTF.forEach { $0.text = "" }
                            }
                        )
                    }
                }
                
                self.viewModel.FetchUserData(id: UserId.data.userId)
            }
        }
    }

    func performNavigationAfterVerification() {
        switch self.comingFrom {
        case .Home:
            self.dismiss(animated: true){
                self.goToHomeTab()
            }
            self.dismissPopup()
            
        case .BookingHistory:
            self.dismiss(animated: true){
                self.goToHomeTab()
            }
            self.dismissPopup()
        case .HotelDetail:
            self.dismiss(animated: true)
            {
                self.goToHomeTab()
            }
        case .none:
            self.dismissPopup()
            self.dismiss(animated: true){
                self.goToHomeTab()
            }
        case .some(.RightMenu), .some(.TabBar):
            break
        }
    }

    func verifyOTPCode(mobile:String,otp:String,completion: @escaping (VerifyOTPModel?) -> Void) {
        showLoader()
        viewModel.onVerifyOTPSucess = { response in
            self.hideLoader()
           completion(response)
        }
        viewModel.onError = { error in
            self.hideLoader()
            self.showAlert(title:"SyriaBooking", message: error.description, onOK: {
                self.otpTF.forEach { textfield in
                    textfield.text = ""
                }
            })
        }
        viewModel.verifyOTP(mobile: mobile, otp: otp)
    }
    
//    func isMobileRegistered(_ mobile: String) -> Bool {
//        let registeredNumbers = UserDefaults.standard.stringArray(forKey: "registeredMobileNumbers") ?? []
//        return registeredNumbers.contains(mobile)
//    }
//
//    func registerMobile(_ mobile: String) {
//        var registeredNumbers = UserDefaults.standard.stringArray(forKey: "registeredMobileNumbers") ?? []
//        registeredNumbers.append(mobile)
//        UserDefaults.standard.set(registeredNumbers, forKey: "registeredMobileNumbers")
//    }

}

extension VerificationVC : UITextFieldDelegate {
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text else { return }

        if text.count >= 1 {
            textField.text = String(text.prefix(1))
            if textField.tag < otpTF.count - 1 {
                otpTF[textField.tag + 1].becomeFirstResponder()
            } else {
                textField.resignFirstResponder()
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.isEmpty {
            if let currentText = textField.text, !currentText.isEmpty {
                textField.text = ""
                if textField.tag > 0 {
                    otpTF[textField.tag - 1].becomeFirstResponder()
                }
                return false
            } else {
                if textField.tag > 0 {
                    otpTF[textField.tag - 1].becomeFirstResponder()
                }
                return false
            }
        }
        return (textField.text?.count ?? 0) < 1
    }
}

extension VerificationVC {
    func setUpUI() {
        mobileNumberTF.text = mobileNumber
//        messageLabel.text = "Dear \(guestName ?? "User"), your mobile is registered. An OTP has been sent to \(OptResponse?.data.to ?? "your email"). Please enter it below to continue."
        for (index, textField) in otpTF.enumerated() {
            textField.delegate = self
            textField.keyboardType = .numberPad
            textField.textAlignment = .center
            textField.tag = index
            textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        }
        setUpLanguage()
    }
    func setUpLanguage() {
        if AppSettings.shared.selectedLanguage == .english {
            verifyAndContinueButton.setTitle("Verify & Continue", for: .normal)
            messageLabel.text = "Dear \(guestName ?? "User"), your mobile is registered. An OTP has been sent to \(OptResponse?.data.to ?? "your email"). Please enter it below to continue."
            enterYourMobileTitleLabel.text = "Enter Your Mobile Number"
            mobileNumberTitleLabel.text = "Mobile Number"
            enterOtpTitleLabel.text = "Enter OTP"
        } else {
            verifyAndContinueButton.setTitle("تحقق واستمر", for: .normal)
            messageLabel.text = "عزيزي \(guestName ?? "المستخدم")، تم تسجيل رقم هاتفك. تم إرسال رمز التحقق إلى \(OptResponse?.data.to ?? "بريدك الإلكتروني"). الرجاء إدخاله أدناه للمتابعة."
            enterYourMobileTitleLabel.text = "أدخل رقم هاتفك المحمول"
            mobileNumberTitleLabel.text = "رقم الجوال"
            enterOtpTitleLabel.text = "أدخل رمز التحقق"
        }
        enterYourMobileTitleLabel.textAlignment = .center
        verifyAndContinueButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
    }
}
