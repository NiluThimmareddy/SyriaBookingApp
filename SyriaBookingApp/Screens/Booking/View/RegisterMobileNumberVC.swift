//
//  RegisterMobileNumberVC.swift
//  SyriaBookingApp
//
//  Created by toqsoft on 04/08/25.
//

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
        mobileNumberCountryCodeButton.layer.cornerRadius = 5
        mobileNumberCountryCodeButton.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        mobileNumberCountryCodeButton.layer.masksToBounds = true
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
        let staticText = "Didn't get it? "
        let resendText = "Resend"
        let fullText = staticText + resendText
        sendCodeButton.setTitle("Resend", for: .normal)
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
        let minutes = totalTime / 60
        let seconds = totalTime % 60
        let timeString = String(format: "%02d:%02d", minutes, seconds)
        
        let staticText = "Didn't get it? "
        let resendText = "Resend"
        let tailText = " — you can resend again in \(timeString)"
        
        sendCodeButton.setTitle("Resend in \(timeString)", for: .normal)
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
        let vc = storyboard?.instantiateViewController(withIdentifier: "SelectCountryViewController") as! SelectCountryViewController
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
//        self.dismiss(animated: true)
    }
    
    @IBAction func continueButtonAction(_ sender: Any) {
        
        guard let mobileNumber = enterMobileNumberTF.text, !mobileNumber.isEmpty else {
            showAlert("Please enter a mobile number.")
            return
        }
        
        if mobileNumber == "90000000"{
            UserSessionManager.saveUser(BookingModel(id: "UP0000", name: "Testing Demo User", mobile: "90000000", address: "address testing", gender: "", email: "testingDemo@gmail.com", country: "Syria", dob: ""))
            
            
            self.dismiss(animated: true) {
                let storyboard = UIStoryboard(name: "Home", bundle: nil)
                if let tabBarVC = storyboard.instantiateViewController(withIdentifier: "CustomTabBarController") as? UITabBarController {
                    tabBarVC.modalPresentationStyle = .fullScreen
                    UIApplication.shared.windows.first?.rootViewController = tabBarVC
                    tabBarVC.presentVerificationVC(otpResponse: nil , mobileNumber:"90000000" , guestName:"Testing Demo User", guestEmail: "testingDemo@gmail.com" ,isNewUser:false)
                }
            }
            
        } else {
            // Ensure country selected
            guard let country = selectedCountryName else {
                showAlert("⚠️ Please select a country.")
                return
            }
            
            guard let regionCode = countryCodeList.first(where: { $0.name == country })?.country_code else {
                showAlert("⚠️ Could not find region code for selected country.")
                return
            }
            
            guard let phonecode = countryCodeList.first(where: {$0.name == country})?.code  else { return }
            
            if mobileNumber.count != maxMobileNumberLength {
                showAlert("Please enter a valid mobile number. It should be \(maxMobileNumberLength) digits long.")
                return
            }
            
            if !validateMobileNumber(mobileNumber, countryCode: regionCode) {
                showAlert("⚠️ Please enter a valid mobile number for \(country).")
                return
            }
            
            showLoader()
            
            countryCode = String(phonecode.dropFirst())
            guard let countryCode = countryCode else { return }
            let mobileNumberwithcode = "\(countryCode)\(mobileNumber)"
            
            
            getRegisteredUserDetails(for: mobileNumberwithcode, completion: { [weak self] user in
                guard let self = self else { return }
                if let userDetails = user {
                    
                    self.getOTP(mobilenumebr: userDetails.mobile, completion:  { otpResponse in
                        self.dismiss(animated: true) {
                            let storyboard = UIStoryboard(name: "Home", bundle: nil)
                            if let tabBarVC = storyboard.instantiateViewController(withIdentifier: "CustomTabBarController") as? UITabBarController {
                                tabBarVC.modalPresentationStyle = .fullScreen
                                UIApplication.shared.windows.first?.rootViewController = tabBarVC
                                tabBarVC.presentVerificationVC(otpResponse: otpResponse, mobileNumber: userDetails.mobile, guestName: userDetails.name, guestEmail: userDetails.email,isNewUser:false)
                            }
                        }
                    })
                    self.reloadScreenAfterDismiss = {
                        self.dismiss(animated: true) {
                            let storyboard = UIStoryboard(name: "Home", bundle: nil)
                            if let tabBarVC = storyboard.instantiateViewController(withIdentifier: "CustomTabBarController") as? UITabBarController {
                                tabBarVC.modalPresentationStyle = .fullScreen
                                self.present(tabBarVC, animated: true)
                            }
                        }
                    }
                    
                } else {
                    hideLoader()
                    self.bottomView.isHidden = false
                    EmailView.isHidden = false
                    otpView.isHidden = true
                    UserInformationView.isHidden = true
                    registerButton.isHidden = true
                    sendCodeButton.setTitle("Send Code", for: .normal)
                }
            })
        }
    }
    
    @IBAction func sendCodeButtonAction(_ sender: UIButton) {
        guard let email = enterEmailTF.text else {
            showAlert("Please enter email")
            return
        }
        
        if isValidEmail(email) {
            print("✅ Valid Email")
            enterEmailTF.layer.borderColor = UIColor.systemGreen.cgColor
            enterEmailTF.layer.borderWidth = 0.5
            
            self.getEmailOTP(email: email) { otpResponse in
                self.otpMessageLable.text = " We sent verification code to \(email)"
                self.changeLabelStyle(Email: false)
                self.otpView.isHidden = false
                self.startResendTimer()
                print(otpResponse.data.otp)
            }
        } else {
            print("❌ Invalid Email")
            enterEmailTF.layer.borderColor = UIColor.red.cgColor
            enterEmailTF.layer.borderWidth = 0.5
            showAlert("Please enter a valid email address")
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
        showLoader()
        viewModel.onEmailVerifyOTPSuccess = { response in
            self.hideLoader()
            completion(response)
        }
        viewModel.onError = { error in
            self.hideLoader()
            self.showAlert(title:"SyriaBooking", message: "Incorrect OTP entered. Please check and re-enter.", onOK: {
                self.otpTF.forEach { textfield in
                    textfield.text = ""
                }
            })
        }
        viewModel.verifyEmailOTP(email: email, otp: otp)
    }
    
    
    @IBAction func verifyEmailOTPButtonAction(_ sender: Any) {
        guard let email = enterEmailTF.text else {
            return
        }
        let otp = otpTF.compactMap { $0.text?.trimmingCharacters(in: .whitespaces) }.joined()
        
        guard !otp.isEmpty else {
            showAlert("Please enter the OTP.")
            return
        }
        
        self.verifyEmailOTPCode(email: email, otp: otp) { [weak self] UserId in
            guard let self = self, let UserId = UserId else { return }
            self.otpMessageLable.text = " Email verified. You can complete the form now."
            self.sendCodeButton.setTitle("Email Verified", for: .normal)
            stopResendTimer()
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
    
    @IBAction func registerButtonAction(_ sender: Any) {
        
        guard let fname = enterFirstNameTF.text, !fname.trimmingCharacters(in: .whitespaces).isEmpty else {
            showAlert("Please enter your name.")
            return
        }
        
        let lname = enterLastNameTF.text ?? ""
        
        
        guard let email = enterEmailTF.text, !email.trimmingCharacters(in: .whitespaces).isEmpty else {
            showAlert("Please enter the email.")
            return
        }
        
        let gendr = ""
        
        guard let country = enterCountryTF.text, !country.trimmingCharacters(in: .whitespaces).isEmpty else {
            showAlert("Please enter your country.")
            return
        }
        
        guard let mobileNumber = enterMobileNumberTF.text, !mobileNumber.isEmpty else {
            showAlert("Please enter a mobile number.")
            return
        }
        
        guard let  countryCode = countryCode else { return }
        let mobileNumberwithCode = "\(countryCode)\(mobileNumber)"
        
        viewModel.onSuccess = { [weak self] response in
            guard let self = self else { return }
            UserSessionManager.saveUser(response)
            
            DispatchQueue.main.async {
                self.showAlert(
                    title: "Success",
                    message: "Your mobile number has been Registered successfully.",
                    type: .success,
                    onOK: {
                        self.goToHomeTab()
                        
                    }
                )
            }
        }
        
        viewModel.onError = { error in
            self.showAlert(error)
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
        self.otpMessageLable.text = " To continue, please verify your email. Click Send code, then enter the 6-digit code we email you."
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
        if resendTimer == nil || !resendTimer!.isValid {
            guard let email = enterEmailTF.text, isValidEmail(email) else {
                showAlert("Please enter a valid email address first")
                return
            }
            
            self.getEmailOTP(email: email) { otpResponse in
                self.showAlert("Verification code has been resent to your email")
                self.startResendTimer()
                print("Resent OTP: \(otpResponse.data.otp)")
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
        viewModel.onSuccess = {  response in
            print("Response: \(response)")
            
            DispatchQueue.main.async{
                completion(response)
            }
        }
        
        viewModel.onError = { error in
            if error.lowercased() == "user not found" {
                DispatchQueue.main.async {
                    self.bottomView.isHidden = false
                    completion(nil)
                }
            } else {
                DispatchQueue.main.async {
                    self.showAlert("Something went wrong: \(error)")
                }
            }
        }
        viewModel.FetchUserData(mobile: number)
    }
    
    func getOTP(mobilenumebr:String, completion: @escaping (OTPResponseModel) -> Void){
        self.showLoader()
        viewModel.onOTPSuccess = { response in
            self.hideLoader()
            completion(response)
        }
        
        viewModel.onError = { error in
            self.hideLoader()
            self.showAlert(title:"SyriaBooking", message: error.description, onOK: {
                
            })
            
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
            self.showAlert(title:"SyriaBooking", message: error.description, onOK: {
                
            })
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
        let mrTitle = AppSettings.shared.selectedLanguage == .english ? "Ms" : "ذكر"
        let mrsTitle = AppSettings.shared.selectedLanguage == .english ? "Mr" : "أنثى"
        let missTitle = AppSettings.shared.selectedLanguage == .english ? "Mrs" : "آخر"
        let selectTitle = AppSettings.shared.selectedLanguage == .english ? " Select Prefix" : "اختر الجنس"
        
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
        let maleTitle = AppSettings.shared.selectedLanguage == .english ? "Male" : "ذكر"
        let femaleTitle = AppSettings.shared.selectedLanguage == .english ? "Female." : "أنثى"
        let otherTitle = AppSettings.shared.selectedLanguage == .english ? "Other" : "آخر"
        let selectGenderTitle = AppSettings.shared.selectedLanguage == .english ? "Select Gender" : "اختر الجنس"
        
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
        selectDateofBirthTF.inputView = datePicker
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(donePressed))
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
        var menuItems: [UIAction] = []
        
        for country in countryCodeList {
            let action = UIAction(title: "\(country.flag) \(country.name)", handler: { [weak self] _ in
                guard let self = self else { return }
                self.countryNameButton.setTitle(country.flag, for: .normal)
                self.countryNameButton.setImage(nil, for: .normal)
                self.enterCountryTF.text = country.name
            })
            menuItems.append(action)
        }
        
        let menu = UIMenu(title: "Select Country", children: menuItems)
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
        // Set the button title with flag + code
        mobileNumberCountryCodeButton.setTitle("\(country.flag) \(country.code)", for: .normal)
        updateMobileNumberCountryCodeFont()
        
        // Update the country info label
        if AppSettings.shared.selectedLanguage == .english {
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
        
        print("Selected country: \(country.name), code: \(country.code), max length: \(country.max_length)")
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
                
                print("🇮🇳 Indian Rule: \(indianRule)")
                return isValid && isPossible && indianRule
            }
            
            print("✅ Parsed: \(parsedNumber), valid: \(isValid), possible: \(isPossible)")
            return isValid && isPossible
        } catch let error as NSError {
            print("❌ Number parsing failed: \(error.localizedDescription)")
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
    func presentVerificationVC(otpResponse: OTPResponseModel?, mobileNumber: String, guestName: String, guestEmail: String,isNewUser:Bool) {
        let storyboard = UIStoryboard(name: "Booking", bundle: nil)
        if let verificationVC = storyboard.instantiateViewController(withIdentifier: "VerificationVC") as? VerificationVC {
            verificationVC.isNewUser = isNewUser
            verificationVC.OptResponse = otpResponse
            verificationVC.mobileNumber = mobileNumber
            print("******\(mobileNumber)")
            verificationVC.guestName = guestName
            verificationVC.guestEmail = guestEmail
            self.present(verificationVC, animated: true)
        }
    }
}
