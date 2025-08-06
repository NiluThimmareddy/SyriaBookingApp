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
    var genderData = ["Male","Female","Others"]
    var selectedOption: chooseOptions = .add
    var otherGuestsEdit: Guest?
    var otherGuestsDelete: Guest?
    private var isChecked = false
    let color = UIColor(named: "defaultColor")
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
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
            
            let add = NSAttributedString(
                string: "Edit Traveller",
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
            
            let add = NSAttributedString(
                string: "Delete Traveller",
                attributes: [.font: UIFont.poppinsMedium(16), .foregroundColor: UIColor.white]
            )
            addNewTravellerButton.setAttributedTitle(add, for: .normal)
            addNewTravellerButton.backgroundColor =  .red
        }
    }
   
    @objc func dismissKeyboard() {
         view.endEditing(true)
    }
    
    func buttonBoldText(){
        let ok = NSAttributedString(
            string: "Ok",
            attributes: [.font: UIFont.poppinsBold(16), .foregroundColor: UIColor.systemBlue]
        )
        okButton.setAttributedTitle(ok, for: .normal)
        
        let cancel = NSAttributedString(
            string: "Cancel",
            attributes: [.font: UIFont.poppinsBold(16), .foregroundColor: UIColor.systemBlue]
        )
        cancelButton.setAttributedTitle(cancel, for: .normal)
        
        let dob = NSAttributedString(
            string: "Select your DOB",
            attributes: [.font: UIFont.poppinsMedium(14), .foregroundColor: UIColor.black]
        )
        dobButton.setAttributedTitle(dob, for: .normal)
        
        let gender = NSAttributedString(
            string: "Select your gender",
            attributes: [.font: UIFont.poppinsMedium(14), .foregroundColor: UIColor.black]
        )
        genderButton.setAttributedTitle(gender, for: .normal)
        
        let add = NSAttributedString(
            string: "Add New Traveller",
            attributes: [.font: UIFont.poppinsMedium(16), .foregroundColor: UIColor.white]
        )
        addNewTravellerButton.setAttributedTitle(add, for: .normal)
        
        selectDateLbl.font = UIFont.poppinsBold(16)
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
        guard isChecked else {
            showAlert(title: "Alert", message: "Please confirm with the checkbox")
            return
        }

        guard let firstName = firstNameTF.text, !firstName.isEmpty,
              let lastName = lastNameTF.text, !lastName.isEmpty,
              let dob = dobButton.title(for: .normal), dob != "Select your DOB",
              let gender = genderButton.title(for: .normal), gender != "Select your gender"
        else {
            showAlert(title: "Missing Info", message: "Please fill all the fields before submitting.")
            return
        }

        switch selectedOption {
        case .add:
            addGuest()
            dismiss(animated: true)

        case .edit:
            showConfirmationAlert(
                title: "Edit Traveller",
                message: "Are you sure you want to update this traveller?",
                actionTitle: "Edit"
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
            addNewTravellerButton.backgroundColor = color
        } else {
            addNewTravellerButton.backgroundColor = UIColor(named: "bicolour.lightgray") ?? .lightGray
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
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: actionTitle, style: isDestructive ? .destructive : .default) { _ in
            confirmed()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(cancelAction)
        alert.addAction(confirmAction)
        
        present(alert, animated: true)
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
