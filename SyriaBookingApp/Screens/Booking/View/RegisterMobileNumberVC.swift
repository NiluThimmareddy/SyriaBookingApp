//
//  RegisterMobileNumberVC.swift
//  SyriaBookingApp
//
//  Created by toqsoft on 04/08/25.

import UIKit
import libPhoneNumber

enum ComingFromToLogin {
    case tabbarBooking
    case HomeSliderView
    case HotelDetails
    case profile
}

class RegisterMobileNumberVC : BaseViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var enterMobileNumberTF: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var enterFirstNameTF: UITextField!
    @IBOutlet weak var enterLastNameTF: UITextField!
    @IBOutlet weak var mobileNumberTF: UITextField!
    @IBOutlet weak var enterEmailTF: UITextField!
    @IBOutlet weak var enterAddressTF: UITextField!
    @IBOutlet weak var selectGenderButton: UIButton!
    @IBOutlet weak var chevronImgView: UIImageView!
    @IBOutlet weak var enterCountryTF: UITextField!
    @IBOutlet weak var selectDateofBirthTF: UITextField!
    @IBOutlet weak var bottomViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var mobileNumberCountryCodeButton: UIButton!
    @IBOutlet weak var countryNameButton: UIButton!
    @IBOutlet weak var countryMobileNoCountLabel: UILabel!
    @IBOutlet weak var enterYourMobileTitleLabel: UILabel!
    @IBOutlet weak var mobileNumberTitleLabel: UILabel!
    @IBOutlet weak var mobileNumberNoteLabel: UILabel!
    @IBOutlet weak var nameTitleLabel: UILabel!
    @IBOutlet weak var emailTitleLabel: UILabel!
    @IBOutlet weak var genderTitleLabel: UILabel!
    @IBOutlet weak var countryTitleLabel: UILabel!
    @IBOutlet weak var dateOfBirthTitleLabel: UILabel!
    @IBOutlet var otpTF: [UITextField]!
    @IBOutlet weak var EmailView: UIView!
    @IBOutlet weak var otpView: UIView!
    @IBOutlet weak var UserInformationView: UIView!
    @IBOutlet weak var selectPrefixButton: UIButton!
    @IBOutlet weak var emailViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var otpMessageLable: UILabel!
    @IBOutlet weak var otpViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var userInformationViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var resendLabel: UILabel!
    @IBOutlet weak var sendCodeButton: UIButton!
    @IBOutlet weak var userInformationTopConstraint: NSLayoutConstraint!
    
    var shouldShowBottomView = false
    var prefilledMobileNumber: String?
    var datePickerContainerView: UIView!
    var datePicker: UIDatePicker!
    var activeButton: UIButton?
    var isDatePickerShown = false
    var selectedCountryName : String?
    var selectedCountryFlag : String?
    var viewModel = BookingViewModel()
    var loginViewModel = LoginViewModel(apicalClient: APIClient.shared)
    var registerUserDetails : BookingModel?
    var countryCodeList : [CountryModel] = []
    var maxMobileNumberLength: Int = 10
    var isFullScreenIfMobileNotRegistered: Bool = false
    var comingFrom : ComingFromToLogin?
    var countryCode : String?
    var reloadScreenAfterDismiss : (() -> Void)?
    
    var resendTimer: Timer?
    var totalTime = 300
    var resendTap: UITapGestureRecognizer?
    
    //    private lazy var loginViewModel = LoginViewModel(apiClient: )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        hideKeyboardWhenTappedAround()
        enterMobileNumberTF.delegate = self
        enterFirstNameTF.delegate = self
        enterLastNameTF.delegate = self
        enterEmailTF.delegate = self
        enterCountryTF.delegate = self
    }
    
    @objc func updateTexts() {
        // Update all UI elements when language changes
        setUpLanguage()
        updateResendCountdownText()
        setupPrefixPullDownMenu()
        setupGenderPullDownMenu()
        
        if let selectedCountry = selectedCountryName,
           let country = countryCodeList.first(where: { $0.name == selectedCountry }) {
            // Update country info label with localized text
            if AppSettings.shared.selectedLanguage == .arabic {
                countryMobileNoCountLabel.text = "الرجاء إدخال رقم جوال مكون من \(country.max_length) أرقام"
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        otpTF.first?.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopResendTimer()
    }
    
    deinit {
        stopResendTimer()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mobileNumberCountryCodeButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        
        enterMobileNumberTF.layer.cornerRadius = 5
        enterMobileNumberTF.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        enterMobileNumberTF.layer.masksToBounds = true
        mobileNumberCountryCodeButton.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
    }
    
    // MARK: - Timer Methods
    func startResendTimer() {
        // Invalidate any existing timer
        stopResendTimer()
        
        totalTime = 300 // 5 minutes in seconds
        updateResendCountdownText()
        // Create and start new timer
        resendTimer = Timer.scheduledTimer(timeInterval: 1.0,target: self,selector: #selector(updateTimer),userInfo: nil,repeats: true)
        
        // Ensure timer runs even when scrolling
        RunLoop.main.add(resendTimer!, forMode: .common)
    }
    
    @objc func updateTimer() {
        if totalTime > 0 {
            totalTime -= 1
            updateResendCountdownText()
        } else {
            stopResendTimer()
            enableResendButton()
        }
    }
    
    func stopResendTimer() {
        resendTimer?.invalidate()
        resendTimer = nil
    }
    
    func enableResendButton() {
        let lang = AppSettings.shared.selectedLanguage
        let staticText = lang == .arabic ? "لم تستلمه؟ " : "Didn't get it? "
        let resendText = lang == .arabic ? "إعادة إرسال" : "Resend"
        let fullText = staticText + resendText
        
        sendCodeButton.setTitle(lang == .arabic ? "إعادة إرسال" : "Resend", for: .normal)
        
        let attributedString = NSMutableAttributedString(string: fullText)
        
        // Style the static text
        attributedString.addAttribute(.foregroundColor, value: UIColor.label,
                                      range: NSRange(location: 0, length: staticText.count))
        attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 13),
                                      range: NSRange(location: 0, length: staticText.count))
        
        // Style the resend text (make it clickable)
        if let resendRange = fullText.range(of: resendText) {
            let nsRange = NSRange(resendRange, in: fullText)
            attributedString.addAttribute(.foregroundColor, value: UIColor.systemBlue,
                                          range: nsRange)
            attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 15, weight: .semibold),
                                          range: nsRange)
            attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue,
                                          range: nsRange)
        }
        
        resendLabel.attributedText = attributedString
        resendLabel.isUserInteractionEnabled = true
        sendCodeButton.isUserInteractionEnabled = true
    }
    
    func updateResendCountdownText() {
        let lang = AppSettings.shared.selectedLanguage
        let minutes = totalTime / 60
        let seconds = totalTime % 60
        let timeString = String(format: "%02d:%02d", minutes, seconds)
        
        let staticText = lang == .arabic ? "لم تستلمه؟ " : "Didn't get it? "
        let resendText = lang == .arabic ? "إعادة إرسال" : "Resend"
        let tailText = lang == .arabic ? " — يمكنك إعادة الإرسال بعد \(timeString)" : " — you can resend again in \(timeString)"
        
        sendCodeButton.setTitle(lang == .arabic ? "إعادة إرسال بعد \(timeString)" : "Resend in \(timeString)", for: .normal)
        
        let fullText = staticText + resendText + tailText
        let attributedString = NSMutableAttributedString(string: fullText)
        
        attributedString.addAttribute(.foregroundColor, value: UIColor.label,
                                      range: NSRange(location: 0, length: fullText.count))
        attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 13),
                                      range: NSRange(location: 0, length: fullText.count))
        
        if let resendRange = fullText.range(of: resendText) {
            let nsRange = NSRange(resendRange, in: fullText)
            attributedString.addAttribute(.foregroundColor, value: UIColor.systemGreen,
                                          range: nsRange)
            attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 15, weight: .semibold),
                                          range: nsRange)
        }
        
        resendLabel.attributedText = attributedString
        resendLabel.isUserInteractionEnabled = false
        sendCodeButton.isUserInteractionEnabled = false
    }
    
    @IBAction func mobileNumberCountryCodeButtonAction(_ sender: Any) {
        updateMobileNumberCountryCodeFont()
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "SelectCountryViewController") as? SelectCountryViewController else{ return }
        vc.countryList = countryCodeList
        vc.delegate = self
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            vc.modalPresentationStyle = .formSheet
            vc.preferredContentSize = CGSize(
                width: UIScreen.main.bounds.width * 0.75,
                height: UIScreen.main.bounds.height * 0.6
            )
        } else {
            if let sheet = vc.sheetPresentationController {
                sheet.detents = [.medium(), .large()]
                sheet.prefersGrabberVisible = true
            }
        }
        present(vc, animated: true)
    }
    
    @IBAction func dismissButtonAction(_ sender: Any) {
        goToHomeTab()
    }
    
    @IBAction func continueButtonAction(_ sender: Any) {
        self.showLoader()
        let lang = AppSettings.shared.selectedLanguage
        let enterMobileMessage = lang == .arabic ? "الرجاء إدخال رقم الهاتف المحمول." : "Please enter a mobile number."
        let selectCountryMessage = lang == .arabic ? "⚠️ الرجاء اختيار البلد." : "⚠️ Please select a country."
        let regionNotFoundMessage = lang == .arabic ? "⚠️ تعذر العثور على رمز المنطقة للبلد المحدد." : "⚠️ Could not find region code for selected country."
        let validMobileMessage = lang == .arabic ? "الرجاء إدخال رقم هاتف محمول صحيح. يجب أن يكون \(maxMobileNumberLength) أرقام." : "Please enter a valid mobile number. It should be \(maxMobileNumberLength) digits long."
        let validForCountryMessage = lang == .arabic ? "⚠️ الرجاء إدخال رقم هاتف محمول صحيح لـ \(selectedCountryName ?? "")." : "⚠️ Please enter a valid mobile number for \(selectedCountryName ?? "")."
        
        guard let countryCode = countryCode else { return }
        guard let mobileNumber = enterMobileNumberTF.text, !mobileNumber.isEmpty else {
            showAlert(enterMobileMessage)
            return
        }
        
        let mobileNumberwithCode = "\(countryCode)\(mobileNumber)"
        
        Task {
            do {
                let response = try await loginViewModel.checkMobile(mobileNumberwithCode)
                
                if response.data.exists {
                    let result = try await loginViewModel.sendOtp(mobileNumberwithCode)
                    DispatchQueue.main.async {
                        self.hideLoader()
                        
                        if let result = result.data {
                            self.dismiss(animated: true) {
                                let storyboard = UIStoryboard(name: "Home", bundle: nil)
                                if let tabBarVC = storyboard.instantiateViewController(withIdentifier: "CustomTabBarController") as? UITabBarController {
                                    
                                    tabBarVC.modalPresentationStyle = .fullScreen
                                    UIApplication.shared.windows.first?.rootViewController = tabBarVC
                                    
                                    tabBarVC.presentOTPScreen(
                                        mobile: mobileNumberwithCode,
                                        email: result.to
                                        
                                    )
                                }
                            }
                        }
                    }
                } else {
                    
                    DispatchQueue.main.async {
                        self.hideLoader()
                        self.bottomView.isHidden = false
                        self.EmailView.isHidden = false
                        self.otpView.isHidden = true
                        self.UserInformationView.isHidden = true
                        self.registerButton.isHidden = true
                        self.sendCodeButton.setTitle(
                            lang == .arabic ? "إرسال الرمز" : "Send Code",
                            for: .normal
                        )
                    }
                }
                
            } catch {
                DispatchQueue.main.async {
                    self.hideLoader()
                    print(error)
                    self.showAlert(error.localizedDescription)
                }
            }
        }
    }
    
    @IBAction func sendCodeButtonAction(_ sender: UIButton) {
        
        let lang = AppSettings.shared.selectedLanguage
        let enterEmailMessage = lang == .arabic ? "الرجاء إدخال البريد الإلكتروني" : "Please enter email"
        let validEmailMessage = lang == .arabic ? "الرجاء إدخال بريد إلكتروني صحيح" : "Please enter a valid email address"
        
        guard let email = enterEmailTF.text?.trimmingCharacters(in: .whitespaces),
              !email.isEmpty else {
            showAlert(enterEmailMessage)
            return
        }
        
        if isValidEmail(email) {
            self.showLoader()
            enterEmailTF.layer.borderColor = UIColor.systemGreen.cgColor
            enterEmailTF.layer.borderWidth = 0.5
            Task{
                do{
                    let response = try await loginViewModel.sendRegistrationEmailOTP(email: email)
                    
                    if response.data != nil {
                        self.hideLoader()
                        if lang == .arabic {
                            self.otpMessageLable.text = "لقد أرسلنا رمز التحقق إلى \(email)"
                        } else {
                            self.otpMessageLable.text = "We sent verification code to \(email)"
                        }
                        self.changeLabelStyle(Email: false)
                        self.otpView.isHidden = false
                        self.startResendTimer()
                    }
                }catch{
                    DispatchQueue.main.async {
                        self.hideLoader()
                        self.showAlert(error.localizedDescription)
                    }
                }
            }
            
        } else {
            enterEmailTF.layer.borderColor = UIColor.red.cgColor
            enterEmailTF.layer.borderWidth = 0.5
            showAlert(validEmailMessage)
            return
        }
    }
    
    func changeLabelStyle(Email:Bool = true){
        if Email {
            self.otpMessageLable.backgroundColor = UIColor.systemGray6
            self.otpMessageLable.textColor = .label
            self.otpMessageLable.layer.cornerRadius = 8
            
        } else {
            self.otpMessageLable.layer.borderWidth = 1.0
            self.otpMessageLable.layer.cornerRadius = 8
            self.otpMessageLable.layer.borderColor = UIColor(hex: "#408558").cgColor
            self.otpMessageLable.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.2)
            self.otpMessageLable.textColor = UIColor(hex: "#408558")
        }
    }
    
    func verifyEmailOTPCode(email:String,otp:String,completion: @escaping (VerifyEmailOTPModel?) -> Void) {
        let lang = AppSettings.shared.selectedLanguage
        showLoader()
        viewModel.onEmailVerifyOTPSuccess = { response in
            self.hideLoader()
            completion(response)
        }
        viewModel.onError = { error in
            self.hideLoader()
            let errorMessage = lang == .arabic ?
            "رمز التحقق غير صحيح. يرجى التحقق وإعادة الإدخال." :
            "Incorrect OTP entered. Please check and re-enter."
            self.showAlert(title: "SyriaBooking", message: errorMessage, onOK: {
                self.otpTF.forEach { textfield in
                    textfield.text = ""
                }
            })
        }
        viewModel.verifyEmailOTP(email: email, otp: otp)
    }
    
    @IBAction func verifyEmailOTPButtonAction(_ sender: Any) {
        let lang = AppSettings.shared.selectedLanguage
        let enterOTPMessage = lang == .arabic ? "الرجاء إدخال رمز التحقق." : "Please enter the OTP."
        
        guard let email = enterEmailTF.text else {
            return
        }
        
        let otp = otpTF.compactMap { $0.text?.trimmingCharacters(in: .whitespaces) }.joined()
        
        guard !otp.isEmpty else {
            showAlert(enterOTPMessage)
            return
        }
        
        Task{
            let response = try await loginViewModel.verifyRegistrationEmailOTP(email: email, otp: otp)
            
            if let response = response.data {
                if response.verified {
                    if lang == .arabic {
                        self.otpMessageLable.text = "تم التحقق من البريد الإلكتروني. يمكنك الآن إكمال النموذج."
                        self.sendCodeButton.setTitle("تم التحقق من البريد الإلكتروني", for: .normal)
                    } else {
                        self.otpMessageLable.text = "Email verified. You can complete the form now."
                        self.sendCodeButton.setTitle("Email Verified", for: .normal)
                    }
                    self.stopResendTimer()
                    self.changeLabelStyle(Email: false)
                    self.UserInformationView.isHidden = false
                    self.registerButton.isHidden = false
                    self.otpView.isHidden = true
                    self.otpViewHeightConstraint.constant = 0
                    self.userInformationTopConstraint.constant = 0
                    self.enterEmailTF.isEnabled = false
                    self.sendCodeButton.isEnabled = false
                }
            }
        }
    }
    
    @IBAction func registerButtonAction(_ sender: Any) {
        let lang = AppSettings.shared.selectedLanguage
        let enterNameMessage = lang == .arabic ? "الرجاء إدخال اسمك." : "Please enter your name."
        let enterEmailMessage = lang == .arabic ? "الرجاء إدخال البريد الإلكتروني." : "Please enter the email."
        let eneterValidEmailMessage = lang == .arabic ? "يرجى إدخال بريد إلكتروني صالح." : "Please enter a valid email."
        let enterCountryMessage = lang == .arabic ? "الرجاء إدخال بلدك." : "Please enter your country."
        let enterMobileMessage = lang == .arabic ? "الرجاء إدخال رقم الهاتف المحمول." : "Please enter a mobile number."
        let successTitle = lang == .arabic ? "نجاح" : "Success"
        let successMessage = lang == .arabic ? "تم تسجيل رقم هاتفك المحمول بنجاح." : "Your mobile number has been Registered successfully."
        
        guard let fname = enterFirstNameTF.text, !fname.trimmingCharacters(in: .whitespaces).isEmpty else {
            showAlert(enterNameMessage)
            return
        }
        
        let lname = enterLastNameTF.text ?? ""
        guard let email = enterEmailTF.text,!email.trimmingCharacters(in: .whitespaces).isEmpty else {
            showAlert(enterEmailMessage)
            return
        }
        
        let gendr = ""
        guard let country = enterCountryTF.text, !country.trimmingCharacters(in: .whitespaces).isEmpty else {
            showAlert(enterCountryMessage)
            return
        }
        
        guard let mobileNumber = enterMobileNumberTF.text, !mobileNumber.isEmpty else {
            showAlert(enterMobileMessage)
            return
        }
        
        guard let countryCode = countryCode else { return }
        let mobileNumberwithCode = "\(countryCode)\(mobileNumber)"
        
        viewModel.onSuccess = { [weak self] response in
            
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                
                let email = self.enterEmailTF.text ?? ""
                let verifyEmailMessage = lang == .arabic
                ? """
                تم إنشاء حسابك بنجاح.
                
                تم إرسال رمز التحقق (OTP) إلى
                
                \(email)
                
                يرجى التحقق من بريدك الإلكتروني للمتابعة.
                """
                : """
                Your account has been registered successfully.
                
                An OTP has been sent to
                
                \(email)
                
                Please verify your email to continue.
                """
                
                self.showAlert(
                    title: successTitle,
                    message: verifyEmailMessage,
                    type: .success,
                    OkButtonTitle: "Continue",
                    onOK: {
                        
                        Task {
                            
                            do {
                                
                                let response = try await self.loginViewModel.senEmailOtp(
                                    email: email
                                )
                                
                                if let data = response.data {
                                    
                                    await MainActor.run {
                                        
                                        self.dismiss(animated: true) {
                                            let storyboard = UIStoryboard(name: "Home", bundle: nil)
                                            if let tabBarVC = storyboard.instantiateViewController(withIdentifier: "CustomTabBarController") as? UITabBarController {
                                                
                                                tabBarVC.modalPresentationStyle = .fullScreen
                                                UIApplication.shared.windows.first?.rootViewController = tabBarVC
                                                
                                                tabBarVC.presentEmailVerificationScreen( email: data.to)
                                            }
                                        }
                                        
                                    }
                                }else{
                                    self.showAlert(response.message)
                                }
                                
                            } catch {
                                
                                await MainActor.run {
                                    
                                    self.showAlert(
                                        title: "Error",
                                        message: error.localizedDescription,
                                        type: .error
                                    )
                                }
                            }
                        }
                    }
                )
            }
        }
        
        viewModel.onError = { error in
            self.showAlert(error.userMessage)
        }
        
        let prefix = selectPrefixButton.titleLabel?.text ?? ""
        let name = "\(prefix) \(fname) \(lname)"
        let dummydob = getDummyDOB()
        viewModel.SubmitUserRegistrationInfo(name: name, mobile: mobileNumberwithCode, gender: gendr , email: email, country: country, dob: selectDateofBirthTF.text ?? dummydob )
    }
}

extension RegisterMobileNumberVC : UITextFieldDelegate {
    func setUpUI() {
        updateResendCountdownText()
        setupResendLabel()
        setupGenderPullDownMenu()
        setupPrefixPullDownMenu()
        selectDateofBirthTF.addTarget(self, action: #selector(dateTextFieldDidChange), for: .editingChanged)
        
        let lang = AppSettings.shared.selectedLanguage
        if lang == .arabic {
            enterMobileNumberTF.placeholder =  "أدخل رقم الهاتف المحمول"
            self.otpMessageLable.text = "للمتابعة، يرجى التحقق من بريدك الإلكتروني. انقر على إرسال الرمز، ثم أدخل الرمز المكون من 6 أرقام الذي أرسلناه إلى بريدك الإلكتروني."
        } else {
            enterMobileNumberTF.placeholder = "Enter Mobile Numeber"
            self.otpMessageLable.text = "To continue, please verify your email. Click Send code, then enter the 6-digit code we email you."
        }
        self.changeLabelStyle(Email: true)
        
        for (index, textField) in otpTF.enumerated() {
            textField.delegate = self
            textField.keyboardType = .numberPad
            textField.textAlignment = .center
            textField.tag = index
            textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        }
        
        EmailView.isHidden = true
        otpView.isHidden = true
        UserInformationView.isHidden = true
        registerButton.isHidden = true
        bottomView.isHidden = !shouldShowBottomView
        if shouldShowBottomView, let number = prefilledMobileNumber {
            mobileNumberTF.text = number
            enterMobileNumberTF.text = number
        }
        
        setupDateOfBirthTextField()
        
        viewModel.loadCountries { countryName in
            self.countryCodeList = countryName
            self.configureCountryNameMenu()
            
            // Set Syria as default country after countries are loaded
            if let syria = countryName.first(where: { $0.name.lowercased() == "syria" }) {
                self.didSelectCountry(syria) // This will update all UI elements
            } else if let firstCountry = countryName.first {
                // Fallback to first country if Syria not found
                self.didSelectCountry(firstCountry)
            }
        }
        enterMobileNumberTF.delegate = self
        setUpLanguage()
    }
    
    func findSyriaCountry() -> CountryModel? {
        return countryCodeList.first { $0.name.lowercased().contains("syria") }
    }
    
    func setupResendLabel() {
        resendLabel.isUserInteractionEnabled = true
        sendCodeButton.isUserInteractionEnabled = true
        resendTap = UITapGestureRecognizer(target: self, action: #selector(resendTapped))
        resendLabel.addGestureRecognizer(resendTap!)
    }
    
    @objc func resendTapped() {
        let lang = AppSettings.shared.selectedLanguage
        let enterEmailMessage = lang == .arabic ? "الرجاء إدخال بريد إلكتروني صحيح أولاً" : "Please enter a valid email address first"
        let resendMessage = lang == .arabic ? "تم إعادة إرسال رمز التحقق إلى بريدك الإلكتروني" : "Verification code has been resent to your email"
        
        if resendTimer == nil || !resendTimer!.isValid {
            guard let email = enterEmailTF.text,!email.trimmingCharacters(in: .whitespaces).isEmpty, isValidEmail(email) else {
                showAlert(enterEmailMessage)
                return
            }
            
            self.getEmailOTP(email: email) { otpResponse in
                self.showAlert(resendMessage)
                self.startResendTimer()
                
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == enterMobileNumberTF {
            if string.isEmpty {
                return true
            }
            
            let allowedCharacters = CharacterSet.decimalDigits
            let characterSet = CharacterSet(charactersIn: string)
            if !allowedCharacters.isSuperset(of: characterSet) {
                return false
            }
            
            let currentText = textField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            
            return updatedText.count <= maxMobileNumberLength
        }
        
        else if otpTF.contains(textField) {
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
        
        return true
    }
    
    func getRegisteredUserDetails(for number: String, completion: @escaping (BookingModel?) -> Void) {
        let lang = AppSettings.shared.selectedLanguage
        let errorMessage = lang == .arabic ? "حدث خطأ ما: " : "Something went wrong: "
        
        Task{
            do{
                let user = try await viewModel.fetchUserByMobile(number)
                
                await MainActor.run {
                    completion(user.data)
                }
            }
            catch let error as NetworkError {
                await MainActor.run {
                    if error.userMessage.lowercased() == "user not found"{
                        self.bottomView.isHidden = false
                    }else{
                        self.showAlert("\(errorMessage) \(error.userMessage)")
                    }
                    
                    completion(nil)
                }
                
            } catch {
                await MainActor.run {
                    self.showAlert(error.localizedDescription)
                    completion(nil)
                }
            }
        }
        
        
    }
    //    
    //    func checkMobileExistence(mobilenumebr:String, completion: @escaping (Bool) -> Void){
    //        let lang = AppSettings.shared.selectedLanguage
    //        self.showLoader()
    //        viewModel.onSuccess = { response in
    //            self.hideLoader()
    //            completion(true)
    //        }
    //        
    //        viewModel.onError = { error in
    //            self.hideLoader()
    //        }
    //        
    //    
    //    }
    
    func getOTP(mobilenumebr:String, completion: @escaping (OTPResponseModel) -> Void){
        let lang = AppSettings.shared.selectedLanguage
        self.showLoader()
        viewModel.onOTPSuccess = { response in
            self.hideLoader()
            completion(response)
        }
        
        viewModel.onError = { error in
            self.hideLoader()
            self.showAlert(title: "SyriaBooking", message: error.userMessage, onOK: {})
        }
        
        viewModel.fetchOTP(mobileNumber: mobilenumebr)
    }
    
    func getEmailOTP(email:String, completion: @escaping (OTPResponseModel) -> Void){
        self.showLoader()
        viewModel.onOTPSuccess = { response in
            self.hideLoader()
            completion(response)
        }
        
        viewModel.onError = { error in
            self.hideLoader()
            self.showAlert(title: "SyriaBooking", message: error.userMessage, onOK: {})
        }
        
        viewModel.fetchEmailOTP(email: email)
    }
    
    func expandToFullScreen() {
        if let sheet = self.sheetPresentationController {
            sheet.animateChanges {
                sheet.selectedDetentIdentifier = .large
            }
        }
    }
    
    func setupPrefixPullDownMenu() {
        let lang = AppSettings.shared.selectedLanguage
        let mrTitle = lang == .arabic ? "السيد" : "Mr"
        let mrsTitle = lang == .arabic ? "السيدة" : "Mrs"
        let missTitle = lang == .arabic ? "الآنسة" : "Ms"
        let selectTitle = lang == .arabic ? "اختر اللقب" : "Select Prefix"
        
        selectPrefixButton.setTitle(selectTitle, for: .normal)
        
        let mr = UIAction(title: mrTitle) { _ in
            self.selectPrefixButton.setTitle(mrTitle, for: .normal)
        }
        
        let mrs = UIAction(title: mrsTitle) { _ in
            self.selectPrefixButton.setTitle(mrsTitle, for: .normal)
        }
        
        let miss = UIAction(title: missTitle) { _ in
            self.selectPrefixButton.setTitle(missTitle, for: .normal)
        }
        
        let prefixMenu = UIMenu(title: "", children: [mr, mrs, miss])
        selectPrefixButton.menu = prefixMenu
        selectPrefixButton.showsMenuAsPrimaryAction = true
    }
    
    func setupGenderPullDownMenu() {
        let lang = AppSettings.shared.selectedLanguage
        let maleTitle = lang == .arabic ? "ذكر" : "Male"
        let femaleTitle = lang == .arabic ? "أنثى" : "Female"
        let otherTitle = lang == .arabic ? "آخر" : "Other"
        let selectGenderTitle = lang == .arabic ? "اختر الجنس" : "Select Gender"
        
        selectGenderButton.setTitle(selectGenderTitle, for: .normal)
        
        let male = UIAction(title: maleTitle) { _ in
            self.selectGenderButton.setTitle(maleTitle, for: .normal)
        }
        
        let female = UIAction(title: femaleTitle) { _ in
            self.selectGenderButton.setTitle(femaleTitle, for: .normal)
        }
        
        let other = UIAction(title: otherTitle) { _ in
            self.selectGenderButton.setTitle(otherTitle, for: .normal)
        }
        
        let genderMenu = UIMenu(title: "", children: [male, female, other])
        selectGenderButton.menu = genderMenu
        selectGenderButton.showsMenuAsPrimaryAction = true
    }
    
    func setupDateOfBirthTextField() {
        selectDateofBirthTF.delegate = self
        selectDateofBirthTF.keyboardType = .numbersAndPunctuation
        
        datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .inline
        datePicker.maximumDate = Date()
        datePicker.addTarget(self, action: #selector(datePickerChanged(_:)), for: .valueChanged)
        datePicker.backgroundColor = .white
        
        let calendarButton = UIButton(type: .system)
        calendarButton.setImage(UIImage(systemName: "calendar"), for: .normal)
        calendarButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        calendarButton.addTarget(self, action: #selector(showDatePicker), for: .touchUpInside)
        calendarButton.tintColor = .black
        selectDateofBirthTF.rightView = calendarButton
        selectDateofBirthTF.rightViewMode = .always
        
        selectDateofBirthTF.inputView = nil
        selectDateofBirthTF.inputAccessoryView = nil
    }
    
    @objc func showDatePicker() {
        let lang = AppSettings.shared.selectedLanguage
        selectDateofBirthTF.inputView = datePicker
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: lang == .arabic ? "تم" : "Done", style: .done, target: self, action: #selector(donePressed))
        toolbar.setItems([doneButton], animated: true)
        selectDateofBirthTF.inputAccessoryView = toolbar
        
        selectDateofBirthTF.reloadInputViews()
        selectDateofBirthTF.becomeFirstResponder()
    }
    
    @objc func donePressed() {
        selectDateofBirthTF.inputView = nil
        selectDateofBirthTF.inputAccessoryView = nil
        selectDateofBirthTF.reloadInputViews()
        selectDateofBirthTF.resignFirstResponder()
    }
    
    @objc func datePickerChanged(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        selectDateofBirthTF.text = formatter.string(from: sender.date)
    }
    
    @objc private func dateTextFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text else { return }
        
        let digits = text.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        
        var result = ""
        for (index, char) in digits.enumerated() {
            result.append(char)
            if index == 3 || index == 5 {
                result.append("-")
            }
            if result.count >= 10 { break }
        }
        
        let currentSelectedRange = textField.selectedTextRange
        textField.text = result
        if let range = currentSelectedRange {
            textField.selectedTextRange = range
        }
        
        if result.count == 10 {
            if !isValidDate(result) {
                textField.textColor = .systemRed
            } else {
                textField.textColor = .label
            }
        } else {
            textField.textColor = .label
        }
    }
    
    private func isValidDate(_ dateString: String) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return dateFormatter.date(from: dateString) != nil
    }
    
    func configureCountryNameMenu() {
        let lang = AppSettings.shared.selectedLanguage
        var menuItems: [UIAction] = []
        
        for country in countryCodeList {
            let action = UIAction(title: "\(country.flag) \(country.name)", handler: { [weak self] _ in
                guard let self = self else { return }
                self.countryNameButton.setTitle(country.flag, for: .normal)
                self.countryNameButton.setImage(nil, for: .normal)
                self.enterCountryTF.text = country.name
                
                // Update the country info label with localized text
                if lang == .arabic {
                    self.countryMobileNoCountLabel.text = "الرجاء إدخال رقم جوال مكون من \(country.max_length) أرقام"
                } else {
                    self.countryMobileNoCountLabel.text = "Please enter a \(country.max_length)-digit mobile number"
                }
            })
            menuItems.append(action)
        }
        
        let menuTitle = lang == .arabic ? "اختر البلد" : "Select Country"
        let menu = UIMenu(title: menuTitle, children: menuItems)
        countryNameButton.menu = menu
        countryNameButton.showsMenuAsPrimaryAction = true
    }
    
    @objc func setUpLanguage() {
        if AppSettings.shared.selectedLanguage == .english {
            enterYourMobileTitleLabel.text = "Enter Your Mobile Number"
            mobileNumberTitleLabel.text = "Mobile Number"
            mobileNumberNoteLabel.text = "Mobile number not registered. Please register below."
            nameTitleLabel.text = "Name"
            emailTitleLabel.text = "Email"
            genderTitleLabel.text = "Gender"
            countryTitleLabel.text = "Country"
            dateOfBirthTitleLabel.text = "Date of Birth"
            updateMobileNumberCountryCodeFont()
            continueButton.setTitle("Continue", for: .normal)
            continueButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
            registerButton.setTitle("Register", for: .normal)
            registerButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        } else {
            enterYourMobileTitleLabel.text = "أدخل رقم هاتفك المحمول"
            mobileNumberTitleLabel.text = "رقم الجوال"
            mobileNumberNoteLabel.text = "رقم الجوال غير مسجل. الرجاء التسجيل أدناه."
            nameTitleLabel.text = "الاسم"
            emailTitleLabel.text = "البريد الإلكتروني"
            genderTitleLabel.text = "الجنس"
            countryTitleLabel.text = "البلد"
            dateOfBirthTitleLabel.text = "تاريخ الميلاد"
            updateMobileNumberCountryCodeFont()
            continueButton.setTitle("متابعة", for: .normal)
            continueButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
            registerButton.setTitle("التسجيل والمتابعة", for: .normal)
            registerButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        }
        mobileNumberNoteLabel.textAlignment = .center
    }
}

extension RegisterMobileNumberVC : SelectCountryDelegate {
    
    func didSelectCountry(_ country: CountryModel) {
        let lang = AppSettings.shared.selectedLanguage
        
        // Set the button title with flag + code
        mobileNumberCountryCodeButton.setTitle("\(country.flag) \(country.code)", for: .normal)
        updateMobileNumberCountryCodeFont()
        
        // Update the country info label
        if lang == .english {
            countryMobileNoCountLabel.text = "Please enter a \(country.max_length)-digit mobile number"
        } else {
            countryMobileNoCountLabel.text = "الرجاء إدخال رقم جوال مكون من \(country.max_length) أرقام"
        }
        
        // Update country selection button
        countryNameButton.setTitle(country.flag, for: .normal)
        countryNameButton.setImage(nil, for: .normal)
        
        // Update country text field
        enterCountryTF.text = country.name
        
        // Store selected country info
        selectedCountryFlag = country.flag
        selectedCountryName = country.name
        maxMobileNumberLength = country.max_length
        
        // Extract country code (remove + sign)
        countryCode = String(country.code.dropFirst())
    }
    
    func updateMobileNumberCountryCodeFont() {
        mobileNumberCountryCodeButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
    }
    
    func validateMobileNumber(_ number: String, countryCode: String) -> Bool {
        guard let phoneUtil = NBPhoneNumberUtil.sharedInstance() else {
            print("❌ Failed to get NBPhoneNumberUtil instance")
            return false
        }
        
        // 1️⃣ Remove whitespaces
        let cleanNumber = number.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // 2️⃣ Ensure only digits (no letters/symbols allowed)
        let digitSet = CharacterSet.decimalDigits
        guard CharacterSet(charactersIn: cleanNumber).isSubset(of: digitSet) else {
            print("❌ Invalid characters found in number")
            return false
        }
        
        do {
            // 3️⃣ Parse with ISO region code (e.g., "IN" for India)
            let parsedNumber = try phoneUtil.parse(cleanNumber, defaultRegion: countryCode)
            
            // 4️⃣ Check if valid & possible
            let isValid = phoneUtil.isValidNumber(parsedNumber)
            let isPossible = phoneUtil.isPossibleNumber(parsedNumber)
            
            // 5️⃣ Extra rule for India
            if countryCode == "IN" {
                let regex = "^[6-9][0-9]{9}$"  // must start with 6–9 and be 10 digits
                let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
                let indianRule = predicate.evaluate(with: cleanNumber)
                
                return isValid && isPossible && indianRule
            }
            
            return isValid && isPossible
        } catch let error as NSError {
#if DEBUG
            print("❌ Number parsing failed: \(error.localizedDescription)")
#endif
            return false
        }
    }
    
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
}

extension UITabBarController {
    func presentVerificationVC(otpResponse: OTPResponseModel?, mobileNumber: String, guestName: String, guestEmail: String, isNewUser: Bool) {
        let storyboard = UIStoryboard(name: "Booking", bundle: nil)
        if let verificationVC = storyboard.instantiateViewController(withIdentifier: "VerificationVC") as? VerificationVC {
            verificationVC.isNewUser = isNewUser
            verificationVC.OptResponse = otpResponse
            verificationVC.mobileNumber = mobileNumber
#if DEBUG
            print("******\(mobileNumber)")
#endif
            verificationVC.guestName = guestName
            verificationVC.guestEmail = guestEmail
            verificationVC.modalPresentationStyle = .overFullScreen
            self.present(verificationVC, animated: true)
        }
    }
    
    func presentOTPScreen(mobile: String,email:String){
        let storyboard = UIStoryboard(name: "Booking", bundle: nil)
        if let verificationVC = storyboard.instantiateViewController(withIdentifier: "VerificationVC") as? VerificationVC {
            verificationVC.mobileNumber = mobile
            verificationVC.guestEmail = email
            verificationVC.flow = .mobileLogin
            verificationVC.modalPresentationStyle = .overFullScreen
            self.present(verificationVC, animated: true)
        }
    }
    
    func presentEmailVerificationScreen(email: String) {
        let storyboard = UIStoryboard(name: "Booking", bundle: nil)
        
        guard let verificationVC = storyboard.instantiateViewController(
            withIdentifier: "VerificationVC"
        ) as? VerificationVC else {
            return
        }
        
        verificationVC.guestEmail = email
        verificationVC.flow = .emailLogin
        verificationVC.modalPresentationStyle = .overFullScreen
        
        self.present(verificationVC, animated: true)
    }
    
}
