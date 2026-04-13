//
//  AddNewTravellerVC.swift
//  HotelBooking
//
//  Created by praveenkumar on 07/07/25.
//

import UIKit

protocol AddNewTravellerDelegate: AnyObject {
    func didEditGuest(_ guest: Guest, at index: Int)
    func didAddGuest(_ guest: Guest)
}

class AddNewTravellerVC: UIViewController, UITextFieldDelegate {

   
    @IBOutlet weak var scrollViewScroll: UIScrollView!
    @IBOutlet weak var confirmTextLbl: UILabel!
    @IBOutlet weak var addNewTravellerButton: UIButton!
    @IBOutlet weak var selectDatePicker: UIDatePicker!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var selectDateLbl: UILabel!
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var dateCloseView: UIView!
    @IBOutlet weak var dateCloseButton: UIButton!
    @IBOutlet weak var selectGenderTV: UITableView!
    @IBOutlet weak var ckeckBoxButton: UIButton!
    @IBOutlet weak var genderButton: UIButton!
    @IBOutlet weak var genderLbl: UILabel!
    @IBOutlet weak var dobButton: UIButton!
    @IBOutlet weak var dobLbl: UILabel!
    @IBOutlet weak var pleaseEnterLbl: UILabel!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var lastNameLbl: UILabel!
    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var firstNameLbl: UILabel!
    @IBOutlet weak var getPermissionLbl: UILabel!
    @IBOutlet weak var addNewTravellersTitle: UILabel!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var closeButton: UIButton!
    
    weak var delegate: AddNewTravellerDelegate?
    var guestIndex: Int?
    
    // Gender data with Arabic translations
    var englishGenderData = ["Male", "Female", "Others"]
    var arabicGenderData = ["ذكر", "أنثى", "آخر"]
    
    var genderData: [String] {
        return AppSettings.shared.selectedLanguage == .arabic ? arabicGenderData : englishGenderData
    }
    
    var selectedOption: chooseOptions = .add
    var otherGuestsEdit: Guest?
    var otherGuestsDelete: Guest?
    private var isChecked = false
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add language change notification observer
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateTexts),
            name: .languageChanged,
            object: nil
        )
        
        backView.layer.cornerRadius = 20
        backView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        backView.clipsToBounds = true
        selectGenderTV.register(UINib(nibName: "UserFeedBackAfterCheckOutTVC", bundle: nil), forCellReuseIdentifier: "UserFeedBackAfterCheckOutTVC")
        selectGenderTV.isHidden = true
        dateCloseView.isHidden = true
        dateCloseButton.alpha = 0.2
        buttonBoldText()
        passedEditData()
        passedDeleteData()
        applyBorder()
        setCheckboxState()
        selectGenderTV.BackViewShadow()
        updateAddTravellerButtonColor()
        selectGenderTV.separatorStyle = .none
        firstNameTF.delegate = self
        lastNameTF.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // Set initial texts
        updateTexts()
    }
    
    @objc func updateTexts() {
        let lang = AppSettings.shared.selectedLanguage
        
        if lang == .arabic {
            // Arabic texts
            addNewTravellersTitle.text = "إضافة ضيف جديد"
            getPermissionLbl.text = "يرجى الحصول على إذن من رفيق سفرك قبل إدخال بياناته الشخصية."
            firstNameLbl.text = "الاسم الأول*"
            lastNameLbl.text = "الاسم الأخير*"
            pleaseEnterLbl.text = "يرجى إدخال اسم هذا الشخص تماماً كما هو مكتوب في جواز سفره أو بطاقة الهوية الرسمية الأخرى."
            confirmTextLbl.text = "أؤكد أنني مفوض بتقديم البيانات الشخصية لأي ضيف مشارك (بما في ذلك الأطفال) إلى SyriaBooking.sy لهذه الخدمة."
            
            // Update button texts
            let addButtonTitle = NSAttributedString(
                string: "إضافة ضيف جديد",
                attributes: [.font: UIFont.poppinsMedium(16), .foregroundColor: UIColor.white]
            )
            addNewTravellerButton.setAttributedTitle(addButtonTitle, for: .normal)
            
            let dobPlaceholder = NSAttributedString(
                string: "اختر تاريخ الميلاد",
                attributes: [.font: UIFont.poppinsMedium(14), .foregroundColor: UIColor.black]
            )
            if dobButton.title(for: .normal) == nil || dobButton.title(for: .normal) == "Select your DOB" {
                dobButton.setAttributedTitle(dobPlaceholder, for: .normal)
            }
            
            let genderPlaceholder = NSAttributedString(
                string: "اختر الجنس",
                attributes: [.font: UIFont.poppinsMedium(14), .foregroundColor: UIColor.black]
            )
            if genderButton.title(for: .normal) == nil || genderButton.title(for: .normal) == "Select your gender" {
                genderButton.setAttributedTitle(genderPlaceholder, for: .normal)
            }
            
            selectDateLbl.text = "اختر التاريخ"
            
            let okTitle = NSAttributedString(
                string: "موافق",
                attributes: [.font: UIFont.poppinsBold(16), .foregroundColor: UIColor.systemBlue]
            )
            okButton.setAttributedTitle(okTitle, for: .normal)
            
            let cancelTitle = NSAttributedString(
                string: "إلغاء",
                attributes: [.font: UIFont.poppinsBold(16), .foregroundColor: UIColor.systemBlue]
            )
            cancelButton.setAttributedTitle(cancelTitle, for: .normal)
            
        } else {
            // English texts
            addNewTravellersTitle.text = "Add New Guest"
            getPermissionLbl.text = "Please get permission from your fellow guest before entering their personal details."
            firstNameLbl.text = "First name*"
            lastNameLbl.text = "Last name*"
            pleaseEnterLbl.text = "Please enter this person's name exactly as written on their passport or other official Identity card."
            confirmTextLbl.text = "I confirm that I'm authorised to provide the personal data of any co-guest (including children) to SyriaBooking.sy for this service."
            
            // Update button texts
            let addButtonTitle = NSAttributedString(
                string: "Add New Guest",
                attributes: [.font: UIFont.poppinsMedium(16), .foregroundColor: UIColor.white]
            )
            addNewTravellerButton.setAttributedTitle(addButtonTitle, for: .normal)
            
            let dobPlaceholder = NSAttributedString(
                string: "Select your DOB",
                attributes: [.font: UIFont.poppinsMedium(14), .foregroundColor: UIColor.black]
            )
            if dobButton.title(for: .normal) == nil || dobButton.title(for: .normal) == "اختر تاريخ الميلاد" {
                dobButton.setAttributedTitle(dobPlaceholder, for: .normal)
            }
            
            let genderPlaceholder = NSAttributedString(
                string: "Select your gender",
                attributes: [.font: UIFont.poppinsMedium(14), .foregroundColor: UIColor.black]
            )
            if genderButton.title(for: .normal) == nil || genderButton.title(for: .normal) == "اختر الجنس" {
                genderButton.setAttributedTitle(genderPlaceholder, for: .normal)
            }
            
            selectDateLbl.text = "Select Date"
            
            let okTitle = NSAttributedString(
                string: "Ok",
                attributes: [.font: UIFont.poppinsBold(16), .foregroundColor: UIColor.systemBlue]
            )
            okButton.setAttributedTitle(okTitle, for: .normal)
            
            let cancelTitle = NSAttributedString(
                string: "Cancel",
                attributes: [.font: UIFont.poppinsBold(16), .foregroundColor: UIColor.systemBlue]
            )
            cancelButton.setAttributedTitle(cancelTitle, for: .normal)
        }
        
        // Reload gender table view
        selectGenderTV.reloadData()
    }
    
    private func setCheckboxState() {
        let imageName = isChecked ? "checkmark.square" : "square"
        ckeckBoxButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let bottomInset = keyboardFrame.height + 10
            scrollViewScroll.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: bottomInset, right: 0)
            scrollViewScroll.scrollIndicatorInsets = scrollViewScroll.contentInset
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        scrollViewScroll.contentInset = .zero
        scrollViewScroll.scrollIndicatorInsets = .zero
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        let textFieldFrame = textField.convert(textField.bounds, to: scrollViewScroll)
        scrollViewScroll.scrollRectToVisible(textFieldFrame.insetBy(dx: 0, dy: -10), animated: true)
    }

    func applyBorder(){
        firstNameTF.layer.cornerRadius = 5
        firstNameTF.layer.borderWidth = 1
        firstNameTF.layer.borderColor = UIColor.lightGray.cgColor
        lastNameTF.layer.cornerRadius = 5
        lastNameTF.layer.borderWidth = 1
        lastNameTF.layer.borderColor = UIColor.lightGray.cgColor
        dobButton.layer.cornerRadius = 5
        dobButton.layer.borderWidth = 1
        dobButton.layer.borderColor = UIColor.lightGray.cgColor
        genderButton.layer.cornerRadius = 5
        genderButton.layer.borderWidth = 1
        genderButton.layer.borderColor = UIColor.lightGray.cgColor
        
    }
    func passedEditData() {
        if let dataGet = otherGuestsEdit{
            firstNameTF.text = dataGet.firstName
            lastNameTF.text = dataGet.lastName
            let dob = NSAttributedString(
                string: dataGet.dob,
                attributes: [.font: UIFont.poppinsMedium(14), .foregroundColor: UIColor.black]
            )
            dobButton.setAttributedTitle(dob, for: .normal)
            
            let gender = NSAttributedString(
                string: dataGet.gender,
                attributes: [.font: UIFont.poppinsMedium(14), .foregroundColor: UIColor.black]
            )
            genderButton.setAttributedTitle(gender, for: .normal)
            
            let lang = AppSettings.shared.selectedLanguage
            let addText = lang == .arabic ? "تعديل الضيف" : "Edit Guest"
            let add = NSAttributedString(
                string: addText,
                attributes: [.font: UIFont.poppinsMedium(16), .foregroundColor: UIColor.white]
            )
            addNewTravellerButton.setAttributedTitle(add, for: .normal)
        }
    }
    
    func passedDeleteData() {
        if let dataGet = otherGuestsDelete{
            firstNameTF.text = dataGet.firstName
            lastNameTF.text = dataGet.lastName
            let dob = NSAttributedString(
                string: dataGet.dob,
                attributes: [.font: UIFont.poppinsMedium(14), .foregroundColor: UIColor.black]
            )
            dobButton.setAttributedTitle(dob, for: .normal)
            
            let gender = NSAttributedString(
                string: dataGet.gender,
                attributes: [.font: UIFont.poppinsMedium(14), .foregroundColor: UIColor.black]
            )
            genderButton.setAttributedTitle(gender, for: .normal)
            
            let lang = AppSettings.shared.selectedLanguage
            let deleteText = lang == .arabic ? "حذف الضيف" : "Delete Guest"
            let add = NSAttributedString(
                string: deleteText,
                attributes: [.font: UIFont.poppinsMedium(16), .foregroundColor: UIColor.white]
            )
            addNewTravellerButton.setAttributedTitle(add, for: .normal)
            addNewTravellerButton.backgroundColor =  .red
        }
    }
   
    func buttonBoldText(){
        let lang = AppSettings.shared.selectedLanguage
        
        let okText = lang == .arabic ? "موافق" : "Ok"
        let ok = NSAttributedString(
            string: okText,
            attributes: [.font: UIFont.poppinsBold(16), .foregroundColor: UIColor.systemBlue]
        )
        okButton.setAttributedTitle(ok, for: .normal)
        
        let cancelText = lang == .arabic ? "إلغاء" : "Cancel"
        let cancel = NSAttributedString(
            string: cancelText,
            attributes: [.font: UIFont.poppinsBold(16), .foregroundColor: UIColor.systemBlue]
        )
        cancelButton.setAttributedTitle(cancel, for: .normal)
        
        let dobPlaceholder = lang == .arabic ? "اختر تاريخ الميلاد" : "Select your DOB"
        let dob = NSAttributedString(
            string: dobPlaceholder,
            attributes: [.font: UIFont.poppinsMedium(14), .foregroundColor: UIColor.black]
        )
        dobButton.setAttributedTitle(dob, for: .normal)
        
        let genderPlaceholder = lang == .arabic ? "اختر الجنس" : "Select your gender"
        let gender = NSAttributedString(
            string: genderPlaceholder,
            attributes: [.font: UIFont.poppinsMedium(14), .foregroundColor: UIColor.black]
        )
        genderButton.setAttributedTitle(gender, for: .normal)
        
        let addText = lang == .arabic ? "إضافة ضيف جديد" : "Add New Guest"
        let add = NSAttributedString(
            string: addText,
            attributes: [.font: UIFont.poppinsMedium(16), .foregroundColor: UIColor.white]
        )
        addNewTravellerButton.setAttributedTitle(add, for: .normal)
        
        selectDateLbl.font = UIFont.poppinsBold(16)
        selectDateLbl.text = lang == .arabic ? "اختر التاريخ" : "Select Date"
        
        addNewTravellersTitle.font = UIFont.poppinsBold(16)
        getPermissionLbl.font = UIFont.poppinsMedium(12)
        pleaseEnterLbl.font = UIFont.poppinsMedium(12)
        firstNameLbl.font = UIFont.poppinsMedium(14)
        firstNameTF.font = UIFont.poppinsMedium(14)
        lastNameLbl.font = UIFont.poppinsMedium(14)
        lastNameTF.font = UIFont.poppinsMedium(14)
        dobLbl.font = UIFont.poppinsMedium(14)
        genderLbl.font = UIFont.poppinsMedium(14)
        confirmTextLbl.font = UIFont.poppinsMedium(12)
    }
    
    @IBAction func ckeckBoxButton(_ sender: Any) {
        isChecked.toggle()
        setCheckboxState()
        updateAddTravellerButtonColor()
    }
    
    @IBAction func genderButton(_ sender: Any) {
        selectGenderTV.isHidden = !selectGenderTV.isHidden
    }
    
    @IBAction func dobButton(_ sender: Any) {
        dateCloseView.isHidden = false
    }
    
    @IBAction func closeButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func dateCloseButton(_ sender: Any) {
        dateCloseView.isHidden = true
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        dateCloseView.isHidden = true
    }
    
    @IBAction func okButton(_ sender: Any) {
        let selectedDate = selectDatePicker.date
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let formattedDate = formatter.string(from: selectedDate)
        
        dobButton.setTitle(formattedDate, for: .normal)
        let ok = NSAttributedString(
            string: formattedDate,
            attributes: [.font: UIFont.poppinsMedium(14), .foregroundColor: UIColor.black]
        )
        dobButton.setAttributedTitle(ok, for: .normal)
        dateCloseView.isHidden = true
    }
    
    func agreeDocument() {
        let lang = AppSettings.shared.selectedLanguage
        let alertTitle = lang == .arabic ? "تنبيه" : "Alert"
        let missingInfoTitle = lang == .arabic ? "معلومات ناقصة" : "Missing Info"
        let confirmMessage = lang == .arabic ? "يرجى تأكيد مربع الاختيار" : "Please confirm with the checkbox"
        let missingMessage = lang == .arabic ? "يرجى ملء جميع الحقول قبل الإرسال." : "Please fill all the fields before submitting."
        
        guard isChecked else {
            showAlert(title: alertTitle, message: confirmMessage)
            return
        }

        guard let firstName = firstNameTF.text, !firstName.isEmpty,
              let lastName = lastNameTF.text, !lastName.isEmpty,
              let dob = dobButton.title(for: .normal),
              (lang == .arabic ? dob != "اختر تاريخ الميلاد" : dob != "Select your DOB"),
              let gender = genderButton.title(for: .normal),
              (lang == .arabic ? gender != "اختر الجنس" : gender != "Select your gender")
        else {
            showAlert(title: missingInfoTitle, message: missingMessage)
            return
        }

        switch selectedOption {
        case .add:
            addGuest()
            dismiss(animated: true)

        case .edit:
            let editTitle = lang == .arabic ? "تعديل الضيف" : "Edit Guest"
            let editMessage = lang == .arabic ? "هل أنت متأكد أنك تريد تحديث هذا المسافر؟" : "Are you sure you want to update this traveller?"
            let editAction = lang == .arabic ? "تعديل" : "Edit"
            
            showConfirmationAlert(
                title: editTitle,
                message: editMessage,
                actionTitle: editAction
            ) {
                self.editGuest()
                self.dismiss(animated: true)
            }
        }
    }

    
    @IBAction func addNewTravellerButton(_ sender: Any) {
        agreeDocument()
        
    }
    
    private func updateAddTravellerButtonColor() {
        if isChecked {
            addNewTravellerButton.backgroundColor = UIColor.label
        } else {
            addNewTravellerButton.backgroundColor = UIColor(named: "bicolour.lightgray") ?? .label
        }
    }
    

    func addGuest() {
        let newGuest = Guest(
            firstName: firstNameTF.text ?? "",
            lastName: lastNameTF.text ?? "",
            dob: dobButton.title(for: .normal) ?? "",
            gender: genderButton.title(for: .normal) ?? ""
        )
        delegate?.didAddGuest(newGuest)
        print("✅ Guest added: \(newGuest)")
    }

    func editGuest() {
        guard let index = guestIndex else { return }
        
        let updatedGuest = Guest(
            firstName: firstNameTF.text ?? "",
            lastName: lastNameTF.text ?? "",
            dob: dobButton.title(for: .normal) ?? "",
            gender: genderButton.title(for: .normal) ?? ""
        )
        
        delegate?.didEditGuest(updatedGuest, at: index)
        print("✏️ Guest edited at index \(index): \(updatedGuest)")
    }

    func showConfirmationAlert(title: String, message: String, actionTitle: String, isDestructive: Bool = false, confirmed: @escaping () -> Void) {
        let lang = AppSettings.shared.selectedLanguage
        let cancelTitle = lang == .arabic ? "إلغاء" : "Cancel"
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: actionTitle, style: isDestructive ? .destructive : .default) { _ in
            confirmed()
        }
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel, handler: nil)
        
        alert.addAction(cancelAction)
        alert.addAction(confirmAction)
        
        present(alert, animated: true)
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension AddNewTravellerVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return genderData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserFeedBackAfterCheckOutTVC")as! UserFeedBackAfterCheckOutTVC
        let data = genderData[indexPath.row]
        cell.backView.backgroundColor = .clear
        cell.titleData.text = data
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = genderData[indexPath.row]
        genderButton.setTitle(data, for: .normal)
      
        let ok = NSAttributedString(
            string: data,
            attributes: [.font: UIFont.poppinsMedium(14), .foregroundColor: UIColor.black]
        )
        genderButton.setAttributedTitle(ok, for: .normal)
        selectGenderTV.isHidden = true
    }
}
