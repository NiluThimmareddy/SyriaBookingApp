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
}

class RegisterMobileNumberVC : UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var enterMobileNumberTF: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var enterNameTF: UITextField!
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
    
    var shouldShowBottomView = false
    var prefilledMobileNumber: String?
    var datePickerContainerView: UIView!
    var datePicker: UIDatePicker!
    var activeButton: UIButton?
    var isDatePickerShown = false
 
    var  selectedCountryName : String?
    var selectedCountryFlag : String?
    var viewModel = BookingViewModel()
    var registerUserDetails : BookingModel?
    var countryCodeList : [CountryModel] = []
    var maxMobileNumberLength: Int = 10
    var isFullScreenIfMobileNotRegistered: Bool = false
    var comingFrom : ComingFromToLogin?
    var countryCode : String?
    var reloadScreenAfterDismiss : (() -> Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    @IBAction func mobileNumberCountryCodeButtonAction(_ sender: Any) {
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
        if comingFrom == .HomeSliderView {
//            self.reloadScreenAfterDismiss?()
            UIApplication.topViewController()?.dismissPopup(ofType: RegisterMobileNumberVC.self)
           
        } else if comingFrom == .tabbarBooking{
            //Move to home page
            UIApplication.topViewController()?.dismissPopup(ofType: RegisterMobileNumberVC.self)
           
            
        } else {
                self.dismiss(animated: true, completion: nil)
            }
    }
    
    @IBAction func continueButtonAction(_ sender: Any) {
       
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
        
        
        guard let mobileNumber = enterMobileNumberTF.text, !mobileNumber.isEmpty else {
            showAlert("Please enter a mobile number.")
            return
        }
      

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

        // You can keep this mapping in your CountryModelpo
       
        getRegisteredUserDetails(for: mobileNumberwithcode, completion: { [weak self] user in
            guard let self = self else { return }
            
            
            //post for get otp
            
            
            if let userDetails = user {
            
                self.getOTP(mobilenumebr: userDetails.mobile, completion:  { otpResponse in
                   
                    let controller = self.storyboard?.instantiateViewController(withIdentifier: "VerificationVC") as! VerificationVC
                   
//                    controller.comingFrom = .
                    controller.OptResponse = otpResponse
                    controller.mobileNumber = userDetails.mobile
                    controller.guestName = userDetails.name
                    controller.guestEmail = userDetails.email
                   
                   
                    self.present(controller, animated: true)
                })
//                self.reloadScreenAfterDismiss?()
//                self.enterNameTF.text = userDetails.name
//                self.enterEmailTF.text = userDetails.email

               
            } else {
                hideLoader()
                if let parentVC = self.parent {
                    parentVC.expandPopupToFullScreen(self)
                    
                }
                self.bottomView.isHidden = false
            }
        })
    }
    
//    func GetFromWhereToComing() -> comingFromLoginSuccess {
//        
//    }

    @IBAction func registerButtonAction(_ sender: Any) {
        guard let name = enterNameTF.text, !name.trimmingCharacters(in: .whitespaces).isEmpty else {
            showAlert("Please enter your name.")
            return
        }
        
        guard let email = enterEmailTF.text, !email.trimmingCharacters(in: .whitespaces).isEmpty else {
            showAlert("Please enter the email.")
            return
        }
        
        guard let gender = selectGenderButton.title(for: .normal), gender != "Select Gender" else {
            showAlert("Please select your gender.")
            return
        }
        
        guard let country = enterCountryTF.text, !country.trimmingCharacters(in: .whitespaces).isEmpty else {
            showAlert("Please enter your country.")
            return
        }
        
        guard var mobileNumber = enterMobileNumberTF.text, !mobileNumber.isEmpty else {
            showAlert("Please enter a mobile number.")
            return
        }
        
        mobileNumber = countryCode ?? "" + mobileNumber
        
        guard let dob = selectDateofBirthTF.text, !dob.trimmingCharacters(in: .whitespaces).isEmpty else {
            showAlert("Please enter your date of birth.")
            return
        }
        
        viewModel.onSuccess = { [weak self] response in
            
            guard let self = self else { return }
//                guard let user = self.registerUserDetails else { return }
//                UserSessionManager.saveUser(user)
                
            self.getOTP(mobilenumebr: response.mobile) { otpResponse in
                let controller = self.storyboard?.instantiateViewController(withIdentifier: "VerificationVC") as! VerificationVC
                controller.OptResponse = otpResponse
                controller.mobileNumber = response.mobile
                controller.guestName = response.name
                controller.guestEmail = response.email
               
              
                self.present(controller, animated: true)
            }
        }
        
        viewModel.onError = { error in
            self.showAlert(error)
        }
        
        viewModel.SubmitUserRegistrationInfo(name: name, mobile: mobileNumber, gender: gender, email: email, country: country, dob: dob)
    }
}

extension RegisterMobileNumberVC : UITextFieldDelegate {
    func setUpUI() {
        changeTheLoginViewDesing()
        setupGenderPullDownMenu()
        selectDateofBirthTF.addTarget(self, action: #selector(dateTextFieldDidChange), for: .editingChanged)

        bottomView.isHidden = !shouldShowBottomView
        if shouldShowBottomView, let number = prefilledMobileNumber {
            mobileNumberTF.text = number
            enterMobileNumberTF.text = number 
        }

        setupDateOfBirthTextField()
        
        viewModel.loadCountries { countryName in
            self.countryCodeList = countryName
            self.configureCountryNameMenu()
        }
        enterMobileNumberTF.delegate = self
        
    }
    
    func changeTheLoginViewDesing(){
        switch comingFrom{
        case .HotelDetails :
            //
            break
        case .tabbarBooking:
            //disable dismissbutton
//            self.dismissButton.isHidden = true
            break
        case .HomeSliderView :
            break
        case .none:
            break
        
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

        return true
    }
    
    func getRegisteredUserDetails(for number: String, completion: @escaping (BookingModel?) -> Void) {
        viewModel.onSuccess = { [weak self] response in
            print("Response: \(response)")
            
            DispatchQueue.main.async{
//

                completion(response)
            }
        }
        
        viewModel.onError = { error in
            
            if error.capitalized == "USER NOT FOUND"{
                completion(nil)
            }else{
                self.showAlert("Something went wrong \(error)")
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
            self.showAlert(error.description)
            
        }
        
        viewModel.fetchOTP(mobileNumber: mobilenumebr)        
    }
    
    
    
    func expandToFullScreen() {
        if let sheet = self.sheetPresentationController {
            sheet.animateChanges {
                sheet.selectedDetentIdentifier = .large
            }
        }
    }

    func setupGenderPullDownMenu() {
        let male = UIAction(title: "Male") { _ in
            self.selectGenderButton.setTitle("Male", for: .normal)
        }

        let female = UIAction(title: "Female") { _ in
            self.selectGenderButton.setTitle("Female", for: .normal)
        }

        let other = UIAction(title: "Other") { _ in
            self.selectGenderButton.setTitle("Other", for: .normal)
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
}

extension RegisterMobileNumberVC : SelectCountryDelegate {
    func didSelectCountry(_ country: CountryModel) {
        mobileNumberCountryCodeButton.setTitle(country.code, for: .normal)
        mobileNumberCountryCodeButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        countryMobileNoCountLabel.text = "Please enter a \(country.max_length ?? 10)-digit mobile number"
        
        countryNameButton.setTitle(country.flag, for: .normal)
        countryNameButton.setImage(nil, for: .normal)
        enterCountryTF.text = country.name
        
        selectedCountryFlag = country.flag
        selectedCountryName = country.name
        maxMobileNumberLength = country.max_length ?? 10
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
}
