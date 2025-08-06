//
//  PersonalDetailsEditVC.swift
//  HotelBooking
//
//  Created by praveenkumar on 10/07/25.
//

import UIKit

protocol PersonalDetailsEditVCDelegate: AnyObject {
    func didUpdateName(firstName: String, lastName: String)
    func didUpdateGender(_ gender: String)
    func didUpdateDOB(_ dob: String)
    func didUpdateEmail(_ email: String)
    func didUpdatePhoneNumber(_ phoneNumber: String, countryCode: String)
    func didUpdateAddress(street: String, city: String, postCode: String, country: String)
}


class PersonalDetailsEditVC: UIViewController {

    @IBOutlet weak var addressCountryNameTV: UITableView!
    @IBOutlet weak var FlagTV: UITableView!
    @IBOutlet weak var dobBackView: UIView!
    @IBOutlet weak var dobSaveButton: UIButton!
    @IBOutlet weak var dobTitle: UILabel!
    @IBOutlet weak var dobDatePicker: UIDatePicker!
    @IBOutlet weak var genderSaveButton: UIButton!
    @IBOutlet weak var genderBackView: UIView!
    @IBOutlet weak var genderTV: UITableView!
    @IBOutlet weak var genderTitle: UILabel!
    @IBOutlet weak var phoneNumberContent: UILabel!
    @IBOutlet weak var phoneNumberErrorMessage: UILabel!
    @IBOutlet weak var phoneNumberTypeTF: UITextField!
    @IBOutlet weak var phoneNumberCountryCodeLbl: UILabel!
    @IBOutlet weak var phoneNumberTypeView: UIView!
    @IBOutlet weak var phoneNumberSaveButton: UIButton!
    @IBOutlet weak var phoneNumberDropDownButton: UIButton!
    @IBOutlet weak var phoneNumberFlageImage: UIImageView!
    @IBOutlet weak var phoneNumberImageAndDropDownView: UIView!
    @IBOutlet weak var phoneNumberTitle: UILabel!
    @IBOutlet weak var phoneNumberView: UIView!
    @IBOutlet weak var addressSmallView: UIView!
    @IBOutlet weak var addressContent: UILabel!
    @IBOutlet weak var addressSaveButton: UIButton!
    @IBOutlet weak var countryNameAddressDropDowmnButton: UIButton!
    @IBOutlet weak var selectedCountryImage: UIImageView!
    @IBOutlet weak var selectedCountryNameLbl: UILabel!
    @IBOutlet weak var countryRegionLbl: UILabel!
    @IBOutlet weak var postCodeTF: UITextField!
    @IBOutlet weak var townTF: UITextField!
    @IBOutlet weak var postCodeLbl: UILabel!
    @IBOutlet weak var townLbl: UILabel!
    @IBOutlet weak var adressTF: UITextField!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var addressTitle: UILabel!
    @IBOutlet weak var addressView: UIView!    
    @IBOutlet weak var emailSaveButton: UIButton!
    @IBOutlet weak var emailTitle: UILabel!
    @IBOutlet weak var emailAddress: UILabel!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var emailContent: UILabel!
    @IBOutlet weak var emailBacView: UIView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var wellSaveContentLbl: UILabel!
    @IBOutlet weak var lastNameLbl: UILabel!
    @IBOutlet weak var firstNameLbl: UILabel!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var nameTitle: UILabel!
    
    let CountryNameViewModel = CountryCodeDataSourceViewModel()
    weak var delegate: PersonalDetailsEditVCDelegate?
    var selectedExpectationIndex: Int? = nil
    var selectedOption: ProfileOptions = .name
    let countryViewModel = CountryListViewModel()
    var personalData: PersonalDetails?
    var genderData = ["Male","Female","Others","Prefer not to say"]
    var color = UIColor(named: "defaultColor")
    var selectedGender: String {
        guard let index = selectedExpectationIndex, index >= 0, index < genderData.count else {
            return ""
        }
        return genderData[index]
    }
    var dobFormattedString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        return formatter.string(from: dobDatePicker.date)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getFlagData()
        flagProcess()
        selectContent()
        applyCornerRadius()
        getData()
        fontText()
        setupDOBPicker()
        tableViewProcess()
        bindViewModel()
        CountryNameViewModel.fetchCountries()
        print("🔍 Available country labels:")
        CountryNameViewModel.countries.forEach { print($0.label) }
        let matchedCountry = CountryNameViewModel.countries.first(where: { $0.label == countryViewModel.countries.first?.name })
        print(matchedCountry ?? "")
    }
    
    func getFlagData(){
        CountryCodeManager.shared.fetchCountryCodes {
            DispatchQueue.main.async {
                self.flagProcess()
                self.FlagTV.reloadData()
                self.addressCountryNameTV.reloadData()
                self.countryViewModel.fetchCountries()
                self.bindViewModel()
            }
        }
        countryViewModel.fetchCountries()
    }
    
    private func bindViewModel() {
        CountryNameViewModel.onDataUpdated = { [weak self] in
            guard let self = self else { return }
            print("✅ Country list loaded: \(self.CountryNameViewModel.countries.count)")
            for country in self.CountryNameViewModel.countries {
                print("🌍 \(country.label)")
            }

            // Moved here: Now it runs after countries are loaded
            if let firstCountryName = self.countryViewModel.countries.first?.name {
                let matchedCountry = self.CountryNameViewModel.countries.first {
                    $0.label == firstCountryName
                }
                print("🎯 Matched country: \(matchedCountry?.label ?? "None")")
            }

            self.FlagTV.reloadData()
            self.addressCountryNameTV.reloadData()
            self.flagProcess()
        }

        CountryNameViewModel.onError = { error in
            print("❌ Error: \(error.localizedDescription)")
        }
    }

    
    func applyCornerRadius(){
        closeButton.alpha =  0.3
        addressSmallView.layer.cornerRadius = 5
        addressSmallView.layer.borderWidth = 1
        addressSmallView.layer.borderColor = UIColor.lightGray.cgColor
        townTF.layer.cornerRadius = 5
        townTF.layer.borderWidth = 1
        townTF.layer.borderColor = UIColor.lightGray.cgColor
        postCodeTF.layer.cornerRadius = 5
        postCodeTF.layer.borderWidth = 1
        postCodeTF.layer.borderColor = UIColor.lightGray.cgColor
        adressTF.layer.cornerRadius = 5
        adressTF.layer.borderWidth = 1
        adressTF.layer.borderColor = UIColor.lightGray.cgColor
        phoneNumberTypeView.layer.cornerRadius = 5
        phoneNumberTypeView.layer.borderWidth = 1
        phoneNumberTypeView.layer.borderColor = UIColor.lightGray.cgColor
        phoneNumberImageAndDropDownView.layer.cornerRadius = 5
        phoneNumberImageAndDropDownView.layer.borderWidth = 1
        phoneNumberImageAndDropDownView.layer.borderColor = UIColor.lightGray.cgColor
        emailTF.layer.cornerRadius = 5
        emailTF.layer.borderWidth = 1
        emailTF.layer.borderColor = UIColor.lightGray.cgColor
        firstNameTF.layer.cornerRadius = 5
        firstNameTF.layer.borderWidth = 1
        firstNameTF.layer.borderColor = UIColor.lightGray.cgColor
        lastName.layer.cornerRadius = 5
        lastName.layer.borderWidth = 1
        lastName.layer.borderColor = UIColor.lightGray.cgColor
        genderTV.register(UINib(nibName: "ExpectationMeetsTVC", bundle: nil), forCellReuseIdentifier: "ExpectationMeetsTVC")
        FlagTV.register(UINib(nibName: "FlagTVC", bundle: nil), forCellReuseIdentifier: "FlagTVC")
        addressCountryNameTV.register(UINib(nibName: "FlagNameWithImageTVC", bundle: nil), forCellReuseIdentifier: "FlagNameWithImageTVC")
        FlagTV.isHidden = true
        addressCountryNameTV.isHidden = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        saveButton.layer.cornerRadius = 10
        genderSaveButton.layer.cornerRadius = 10
        dobSaveButton.layer.cornerRadius = 10
        emailSaveButton.layer.cornerRadius = 10
        phoneNumberSaveButton.layer.cornerRadius = 10
        addressSaveButton.layer.cornerRadius = 10
        phoneNumberErrorMessage.isHidden = true
        phoneNumberTypeTF.keyboardType = .numberPad
    }
    
    @objc func dismissKeyboard() {
         view.endEditing(true)
    }
    
    func getData(){
        if let data = personalData{
            selectedCountryNameLbl.text = data.country
            townTF.text = data.address.city
            postCodeTF.text = data.address.postCode
            adressTF.text = data.address.streetAddress
            firstNameTF.text = data.firstName
            lastName.text = data.lastName
            emailTF.text = data.emailAddress
            let fullNumber = data.phoneNumber
            let digitsOnly = fullNumber.components(separatedBy: " ").last ?? fullNumber
            phoneNumberTypeTF.text = digitsOnly
            let countryCode = fullNumber.components(separatedBy: " ").first ?? ""
            phoneNumberCountryCodeLbl.text = countryCode
        }
    }
    func setupDOBPicker() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        
        if let dobString = personalData?.dateOfBirth, !dobString.isEmpty,
           let dobDate = formatter.date(from: dobString) {
            dobDatePicker.date = dobDate
        } else {
            dobDatePicker.date = Date()
        }
    }

    
    func validatePhoneNumber() {
        guard let number = phoneNumberTypeTF.text?.filter({ $0.isNumber }) else {
            phoneNumberErrorMessage.text = "Please enter a phone number"
            phoneNumberErrorMessage.isHidden = false
            return
        }

        if number.count < 10 {
            phoneNumberErrorMessage.text = "Phone number must be at least 10 digits"
            phoneNumberErrorMessage.isHidden = false
        } else {
            phoneNumberErrorMessage.isHidden = true
        }
    }

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        nameRoundLeftSideCorners()
        emailRoundLeftSideCorners()
        numberRoundLeftSideCorners()
        addressRoundLeftSideCorners()
        dobRoundLeftSideCorners()
        genderRoundTopCorners()
    }
    
    func selectContent() {
        switch selectedOption {
        case .name:
            backView.isHidden = false
            emailBacView.isHidden = true
            phoneNumberView.isHidden = true
            addressView.isHidden = true
            genderBackView.isHidden = true
            dobBackView.isHidden = true
            
        case .gender:
            backView.isHidden = true
            emailBacView.isHidden = true
            phoneNumberView.isHidden = true
            addressView.isHidden = true
            genderBackView.isHidden = false
            dobBackView.isHidden = true
            
        case .email:
            backView.isHidden = true
            emailBacView.isHidden = false
            phoneNumberView.isHidden = true
            addressView.isHidden = true
            genderBackView.isHidden = true
            dobBackView.isHidden = true
            
        case .number:
            backView.isHidden = true
            emailBacView.isHidden = true
            phoneNumberView.isHidden = false
            addressView.isHidden = true
            genderBackView.isHidden = true
            dobBackView.isHidden = true
            
        case .address:
            backView.isHidden = true
            emailBacView.isHidden = true
            phoneNumberView.isHidden = true
            addressView.isHidden = false
            genderBackView.isHidden = true
            dobBackView.isHidden = true
            
        case .dob:
            backView.isHidden = true
            emailBacView.isHidden = true
            phoneNumberView.isHidden = true
            addressView.isHidden = true
            genderBackView.isHidden = true
            dobBackView.isHidden = false
            
        }
    }
    
    func tableViewProcess(){
        if let savedGender = personalData?.gender,
           let index = genderData.firstIndex(where: { $0.lowercased() == savedGender.lowercased() }) {
            selectedExpectationIndex = index
        } else {
            selectedExpectationIndex = -1
        }
    }
    
    func flagProcess() {
        let countryName = selectedCountryNameLbl.text?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() ?? ""
        print("🌍 Looking for flag for: \(countryName)")

        guard let countryCode = CountryCodeManager.shared.nameToCode[countryName] else {
            print("❌ No country code found for \(countryName)")
            selectedCountryImage.image = UIImage(systemName: "photo")
            phoneNumberFlageImage.image = UIImage(systemName: "photo")
            return
        }
        let urlString = "https://flagcdn.com/w40/\(countryCode.lowercased()).png"
        print("🌍 URL: \(urlString)")
        guard let url = URL(string: urlString) else {
            print("❌ Invalid URL")
            selectedCountryImage.image = UIImage(systemName: "photo")
            phoneNumberFlageImage.image = UIImage(systemName: "photo")
            return
        }

        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url),
               let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    print("✅ Flag image loaded for \(countryName)")
                    self.selectedCountryImage.image = image
                    self.phoneNumberFlageImage.image = image
                }
            } else {
                DispatchQueue.main.async {
                    print("❌ Failed to load image from \(urlString)")
                    self.selectedCountryImage.image = UIImage(systemName: "photo")
                    self.phoneNumberFlageImage.image = UIImage(systemName: "photo")
                }
            }
        }
    }
    
    func fontText(){
        nameTitle.font = UIFont.poppinsBold(16)
        firstNameLbl.font = UIFont.poppinsBold(14)
        lastNameLbl.font = UIFont.poppinsBold(14)
        firstNameTF.font = UIFont.poppinsMedium(14)
        lastName.font = UIFont.poppinsMedium(14)
        wellSaveContentLbl.font = UIFont.poppinsMedium(12)
        genderTitle.font = UIFont.poppinsBold(16)
        dobTitle.font = UIFont.poppinsBold(16)
        emailTitle.font = UIFont.poppinsBold(16)
        emailTF.font = UIFont.poppinsMedium(14)
        emailContent.font = UIFont.poppinsMedium(12)
        emailAddress.font = UIFont.poppinsBold(14)
        phoneNumberTitle.font = UIFont.poppinsBold(16)
        phoneNumberTypeTF.font = UIFont.poppinsMedium(14)
        phoneNumberContent.font = UIFont.poppinsMedium(12)
        phoneNumberErrorMessage.font = UIFont.poppinsMedium(14)
        phoneNumberCountryCodeLbl.font = UIFont.poppinsMedium(14)
        addressTitle.font = UIFont.poppinsBold(16)
        addressLbl.font = UIFont.poppinsBold(14)
        townLbl.font = UIFont.poppinsBold(14)
        postCodeLbl.font = UIFont.poppinsBold(14)
        countryRegionLbl.font = UIFont.poppinsBold(14)
        adressTF.font = UIFont.poppinsMedium(14)
        townTF.font = UIFont.poppinsMedium(14)
        postCodeTF.font = UIFont.poppinsMedium(14)
        selectedCountryNameLbl.font = UIFont.poppinsMedium(14)
        addressContent.font = UIFont.poppinsMedium(12)
        
        let nameSave = NSAttributedString(
            string: "Save",
            attributes: [.font: UIFont.poppinsBold(16), .foregroundColor: UIColor.white]
        )
        saveButton.setAttributedTitle(nameSave, for: .normal)
        
        let dobSave = NSAttributedString(
            string: "Save",
            attributes: [.font: UIFont.poppinsBold(16), .foregroundColor: UIColor.white]
        )
        dobSaveButton.setAttributedTitle(dobSave, for: .normal)
        
        let emailSave = NSAttributedString(
            string: "Save",
            attributes: [.font: UIFont.poppinsBold(16), .foregroundColor: UIColor.white]
        )
        emailSaveButton.setAttributedTitle(emailSave, for: .normal)
        
        let numberSave = NSAttributedString(
            string: "Save",
            attributes: [.font: UIFont.poppinsBold(16), .foregroundColor: UIColor.white]
        )
        phoneNumberSaveButton.setAttributedTitle(numberSave, for: .normal)
        
        let genderSave = NSAttributedString(
            string: "Save",
            attributes: [.font: UIFont.poppinsBold(16), .foregroundColor: UIColor.white]
        )
        genderSaveButton.setAttributedTitle(genderSave, for: .normal)
        
        let addressSave = NSAttributedString(
            string: "Save",
            attributes: [.font: UIFont.poppinsBold(16), .foregroundColor: UIColor.white]
        )
        addressSaveButton.setAttributedTitle(addressSave, for: .normal)
    }
    
    private func nameRoundLeftSideCorners() {
        backView.layer.cornerRadius = 50
        backView.layer.maskedCorners = [.layerMinXMinYCorner]
        backView.clipsToBounds = true
    }
   
    private func emailRoundLeftSideCorners() {
        emailBacView.layer.cornerRadius = 50
        emailBacView.layer.maskedCorners = [.layerMinXMinYCorner]
        emailBacView.clipsToBounds = true
    }
    
    private func numberRoundLeftSideCorners() {
        phoneNumberView.layer.cornerRadius = 50
        phoneNumberView.layer.maskedCorners = [.layerMinXMinYCorner]
        phoneNumberView.clipsToBounds = true
    }
    
    private func addressRoundLeftSideCorners() {
        addressView.layer.cornerRadius = 50
        addressView.layer.maskedCorners = [.layerMinXMinYCorner]
        addressView.clipsToBounds = true
    }
    
    private func genderRoundTopCorners() {
        genderBackView.layer.cornerRadius = 50
        genderBackView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        genderBackView.clipsToBounds = true
    }
    
    private func dobRoundLeftSideCorners() {
        dobBackView.layer.cornerRadius = 10
        dobBackView.clipsToBounds = true
    }

    @IBAction func closeButton(_ sender: Any) {
        let transition = CATransition()
            transition.duration = 0.3
            transition.type = .push
            transition.subtype = .fromLeft
            transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)

            view.window?.layer.add(transition, forKey: kCATransition)
            dismiss(animated: false)
    }
    
    @IBAction func emailSaveButton(_ sender: Any) {
        guard let email = emailTF.text, !email.isEmpty else {
            
            return
        }
        delegate?.didUpdateEmail(email)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let transition = CATransition()
            transition.duration = 0.3
            transition.type = .push
            transition.subtype = .fromLeft
            transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            
            self.view.window?.layer.add(transition, forKey: kCATransition)
            self.dismiss(animated: false)
        }
    }
    
    @IBAction func saveButton(_ sender: Any) {
        delegate?.didUpdateName(firstName: firstNameTF.text ?? "", lastName: lastName.text ?? "")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let transition = CATransition()
            transition.duration = 0.3
            transition.type = .push
            transition.subtype = .fromLeft
            transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            
            self.view.window?.layer.add(transition, forKey: kCATransition)
            self.dismiss(animated: false)
        }
    }
    
    @IBAction func countryNameAddressDropDowmnButton(_ sender: Any) {
        addressCountryNameTV.isHidden = !addressCountryNameTV.isHidden
    }
    
    @IBAction func addressSaveButton(_ sender: Any) {
        delegate?.didUpdateAddress(street: adressTF.text ?? "", city: townTF.text ?? "", postCode: postCodeTF.text ?? "", country: selectedCountryNameLbl.text ?? "")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let transition = CATransition()
            transition.duration = 0.3
            transition.type = .push
            transition.subtype = .fromLeft
            transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            
            self.view.window?.layer.add(transition, forKey: kCATransition)
            self.dismiss(animated: false)
        }
    }
    
    @IBAction func phoneNumberDropDownButtonDropDownButton(_ sender: Any) {
        FlagTV.isHidden = !FlagTV.isHidden
    }
    
    @IBAction func phoneNumberSaveButton(_ sender: Any) {
        validatePhoneNumber()
        
        if phoneNumberErrorMessage.isHidden {
            delegate?.didUpdatePhoneNumber(phoneNumberTypeTF.text ?? "", countryCode: phoneNumberCountryCodeLbl.text ?? "")
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let transition = CATransition()
            transition.duration = 0.3
            transition.type = .push
            transition.subtype = .fromLeft
            transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            
            self.view.window?.layer.add(transition, forKey: kCATransition)
            self.dismiss(animated: false)
        }
    }
    
    @IBAction func genderSaveButton(_ sender: Any) {
        delegate?.didUpdateGender(selectedGender)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let transition = CATransition()
            transition.duration = 0.3
            transition.type = .push
            transition.subtype = .fromLeft
            transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            
            self.view.window?.layer.add(transition, forKey: kCATransition)
            self.dismiss(animated: false)
        }
    }
    
    @IBAction func dobSaveButton(_ sender: Any) {
        delegate?.didUpdateDOB(dobFormattedString)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let transition = CATransition()
            transition.duration = 0.3
            transition.type = .push
            transition.subtype = .fromLeft
            transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            
            self.view.window?.layer.add(transition, forKey: kCATransition)
            self.dismiss(animated: false)
        }
    }
    
}

extension PersonalDetailsEditVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == genderTV {
            return genderData.count
        } else if tableView == FlagTV || tableView == addressCountryNameTV {
            return countryViewModel.countries.count
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == genderTV {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ExpectationMeetsTVC", for: indexPath) as! ExpectationMeetsTVC
            let gender = genderData[indexPath.row]
            
            let isSelected = personalData?.gender.lowercased() == gender.lowercased()
            cell.tickImage.image = UIImage(named: isSelected ? "circle-check" : "circle")
            cell.tickImage.tintColor = isSelected ? color : UIColor.darkGray
            cell.titleLbl.text = gender
            return cell
            
        } else if tableView == FlagTV {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FlagTVC", for: indexPath) as! FlagTVC
            let country = countryViewModel.countries[indexPath.row]
            loadFlagImage(for: country.code, into: cell.flagImage, at: indexPath, in: tableView)
            return cell
            
        } else if tableView == addressCountryNameTV {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FlagNameWithImageTVC", for: indexPath) as! FlagNameWithImageTVC
            let country = countryViewModel.countries[indexPath.row]
            cell.nameLbl.text = country.name
            loadFlagImage(for: country.code, into: cell.flagImage, at: indexPath, in: tableView)
            return cell
        }

        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == genderTV {
            selectedExpectationIndex = indexPath.row
            personalData?.gender = genderData[indexPath.row]
            genderTV.reloadData()
            
        } else if tableView == FlagTV {
            let selectedCountry = countryViewModel.countries[indexPath.row]
            print("Selected Country: \(selectedCountry.name)")
            
            if let matchedCountry = CountryNameViewModel.countries.first(where: { $0.label == selectedCountry.name }) {
                phoneNumberCountryCodeLbl.text = "+\(matchedCountry.phone)"
                loadFlagImage(for: selectedCountry.code, into: phoneNumberFlageImage)
            } else {
                print("No match found in countryList for \(selectedCountry.name)")
                phoneNumberCountryCodeLbl.text = ""
                phoneNumberFlageImage.image = UIImage(systemName: "photo")
            }
            FlagTV.isHidden = true
            
        } else if tableView == addressCountryNameTV {
            let selectedCountry = countryViewModel.countries[indexPath.row]
            selectedCountryNameLbl.text = selectedCountry.name
            
            if let matchedCountry = CountryNameViewModel.countries.first(where: { $0.label == selectedCountry.name }) {
                print("Flag URL: https://flagcdn.com/w40/\(matchedCountry.code).png")
                loadFlagImage(for: selectedCountry.code, into: selectedCountryImage)
            } else {
                selectedCountryImage.image = UIImage(systemName: "photo")
                print("Country not found in CountryNameViewModel for code: \(selectedCountry.code)")
            }
            addressCountryNameTV.isHidden = true
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == genderTV || tableView == FlagTV {
            return 40
        } else if tableView == addressCountryNameTV {
            return 50
        }
        return 50
    }


    func loadFlagImage(for countryCode: String, into imageView: UIImageView, at indexPath: IndexPath? = nil, in tableView: UITableView? = nil) {
        let urlString = "https://flagcdn.com/w40/\(countryCode.lowercased()).png"
        guard let url = URL(string: urlString) else {
            imageView.image = UIImage(systemName: "photo")
            return
        }

        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    // Prevent setting image on reused cell
                    if let indexPath = indexPath, let tableView = tableView,
                       let currentIndexPath = tableView.indexPath(for: tableView.cellForRow(at: indexPath) ?? UITableViewCell()),
                       currentIndexPath != indexPath {
                        return
                    }
                    imageView.image = image
                }
            } else {
                DispatchQueue.main.async {
                    imageView.image = UIImage(systemName: "photo")
                }
            }
        }
    }

}
