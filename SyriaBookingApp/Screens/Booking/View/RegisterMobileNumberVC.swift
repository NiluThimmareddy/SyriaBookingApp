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
        }
        setupDateOfBirthTextField()
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
}

