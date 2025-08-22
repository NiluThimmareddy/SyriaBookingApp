//
//  RegisterMobileNumberVC.swift
//  SyriaBookingApp
//
//  Created by toqsoft on 04/08/25.
//

import UIKit

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

    var selectedRoom: RoomElement?
    var selectedHotel: Hotel?
    var selectedRate: Rate?
    
    let registeredUsers: [String: (name: String, email: String)] = [
        "8374926518": (name: "John Doe", email: "john@example.com"),
        "6300121212": (name: "Jane Smith", email: "jane@example.com")
    ]
    
    let countryCodeList: [(name: String, code: String, flag: String, digitCount: Int)] = [
        ("India", "+91", "🇮🇳", 10),
        ("Saudi Arabia", "+966", "🇸🇦", 9),
        ("USA", "+1", "🇺🇸", 10),
        ("UK", "+44", "🇬🇧", 10),
        ("Canada", "+1", "🇨🇦", 10),
        ("Australia", "+61", "🇦🇺", 9),
        ("Germany", "+49", "🇩🇪", 11),
        ("France", "+33", "🇫🇷", 9),
        ("Japan", "+81", "🇯🇵", 10),
        ("South Korea", "+82", "🇰🇷", 10),
        ("UAE", "+971", "🇦🇪", 9),
        ("Brazil", "+55", "🇧🇷", 11),
        ("Mexico", "+52", "🇲🇽", 10),
        ("Russia", "+7", "🇷🇺", 10),
        ("China", "+86", "🇨🇳", 11),
        ("Italy", "+39", "🇮🇹", 10),
        ("Spain", "+34", "🇪🇸", 9),
        ("South Africa", "+27", "🇿🇦", 9),
        ("New Zealand", "+64", "🇳🇿", 9),
        ("Singapore", "+65", "🇸🇬", 8),
        ("Nigeria", "+234", "🇳🇬", 10),
        ("Indonesia", "+62", "🇮🇩", 10),
        ("Turkey", "+90", "🇹🇷", 10),
        ("Argentina", "+54", "🇦🇷", 10)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpUI()
    }

    @IBAction func dismissButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func continueButtonAction(_ sender: Any) {
        guard let mobileNumber = enterMobileNumberTF.text, !mobileNumber.isEmpty else {
            showAlert("Please enter a mobile number.")
            return
        }
        
        if let userDetails = getRegisteredUserDetails(for: mobileNumber) {
            enterNameTF.text = userDetails.name
            enterEmailTF.text = userDetails.email
            
            let controller = storyboard?.instantiateViewController(withIdentifier: "VerificationVC") as! VerificationVC
            controller.mobileNumber = mobileNumber
            controller.guestName = userDetails.name
            controller.guestEmail = userDetails.email
            controller.selectedHotel = selectedHotel
            controller.selectedRoom = selectedRoom
            controller.selectedRate = selectedRate
            present(controller, animated: true)
        } else {
            presentSelfAsFullScreenWithBottomView()
            bottomView.isHidden = false
        }
    }

    @IBAction func registerButtonAction(_ sender: Any) {
        guard let name = enterNameTF.text, !name.trimmingCharacters(in: .whitespaces).isEmpty else {
            showAlert("Please enter your name.")
            return
        }
        
        guard let email = enterEmailTF.text, !email.trimmingCharacters(in: .whitespaces).isEmpty else {
            showAlert("Please enter the email.")
            return
        }
        
//        guard let address = enterAddressTF.text, !address.trimmingCharacters(in: .whitespaces).isEmpty else {
//            showAlert("Please enter your address.")
//            return
//        }
        
        guard let gender = selectGenderButton.title(for: .normal), gender != "Select Gender" else {
            showAlert("Please select your gender.")
            return
        }
        
        guard let country = enterCountryTF.text, !country.trimmingCharacters(in: .whitespaces).isEmpty else {
            showAlert("Please enter your country.")
            return
        }
        
        guard let dob = selectDateofBirthTF.text, !dob.trimmingCharacters(in: .whitespaces).isEmpty else {
            showAlert("Please enter your date of birth.")
            return
        }
        let controller = storyboard?.instantiateViewController(withIdentifier: "VerificationVC") as! VerificationVC
        controller.mobileNumber = mobileNumberTF.text
        controller.guestName = name
        controller.guestEmail = email
        controller.selectedHotel = selectedHotel
        controller.selectedRoom = selectedRoom
        controller.selectedRate = selectedRate
        present(controller, animated: true)
    }
    
}

extension RegisterMobileNumberVC : UITextFieldDelegate {
    func setUpUI() {
        setupGenderPullDownMenu()
        
        bottomView.isHidden = !shouldShowBottomView
        if shouldShowBottomView, let number = prefilledMobileNumber {
            mobileNumberTF.text = number
            enterMobileNumberTF.text = number 
        }
        
        let defaultImage = UIImage(systemName: "flag.fill")
        countryNameButton.setImage(defaultImage, for: .normal)
        countryNameButton.setTitle("", for: .normal)
        countryNameButton.tintColor = .black
        setupDateOfBirthTextField()
        configureCountryCodeMenu()
        configureCountryNameMenu()
    }
    
    func getRegisteredUserDetails(for number: String) -> (name: String, email: String)? {
        return registeredUsers[number]
    }
    
    func presentSelfAsFullScreenWithBottomView() {
        guard let presentingVC = self.presentingViewController else { return }

        let enteredNumber = enterMobileNumberTF.text ?? ""

        self.dismiss(animated: true) {
            let storyboard = UIStoryboard(name: "Booking", bundle: nil)
            guard let fullScreenVC = storyboard.instantiateViewController(withIdentifier: "RegisterMobileNumberVC") as? RegisterMobileNumberVC else { return }

            fullScreenVC.modalPresentationStyle = .overFullScreen
            fullScreenVC.shouldShowBottomView = true
            fullScreenVC.prefilledMobileNumber = enteredNumber
            presentingVC.present(fullScreenVC, animated: true)
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
        formatter.dateFormat = "dd/MM/yyyy"
        selectDateofBirthTF.text = formatter.string(from: sender.date)
    }

    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard textField == selectDateofBirthTF else { return }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        if let dateText = textField.text, formatter.date(from: dateText) == nil {
            showAlert("Please enter a valid date in dd/MM/yyyy format.")
        }
    }
    
    func configureCountryCodeMenu() {
        var menuItems: [UIAction] = []

        for country in countryCodeList {
            let action = UIAction(title: "\(country.flag) \(country.name) \(country.code)", handler: { [weak self] _ in
                guard let self = self else { return }
                self.mobileNumberCountryCodeButton.setTitle(country.code, for: .normal)
                self.mobileNumberCountryCodeButton.titleLabel?.font = UIFont.systemFont(ofSize: 14) 
                self.countryMobileNoCountLabel.text = "Please enter a \(country.digitCount)-digit mobile number"
            })
            menuItems.append(action)
        }

        let menu = UIMenu(title: "Select Country Code", children: menuItems)
        mobileNumberCountryCodeButton.menu = menu
        mobileNumberCountryCodeButton.showsMenuAsPrimaryAction = true
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


