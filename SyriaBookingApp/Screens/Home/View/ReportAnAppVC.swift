//
//  ReportAnAppVC.swift
//  SyriaBookingApp
//
//  Created by toqsoft on 04/09/25.
//


import UIKit

class ReportAnAppVC: BaseViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var insideScrollView: UIView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var selectTypeButton: UIButton!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var enterMessageTextView: UITextView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var contactTitleLabel: UILabel!
    @IBOutlet weak var enterSubjectTF: UITextField!
    @IBOutlet weak var yourNameLabel: UILabel!
    @IBOutlet weak var enterYourNameTF: UITextField!
    @IBOutlet weak var yourEmailLabel: UILabel!
    @IBOutlet weak var enterEmailTF: UITextField!
    @IBOutlet weak var phoneNoLabel: UILabel!
    @IBOutlet weak var enterPhoneNumberTF: UITextField!
    @IBOutlet weak var chevronImgView: UIImageView!
    
    var comingfrom : comingFromLogin?
    var hotelViewModel = HotelViewModel()
    var titleText: String?
    var type = ""
    var hotelID = ""
    var hotelName = ""
    var BookingID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        topView.layer.cornerRadius = 10
        topView.addBottomShadow()
        setupContactUsTypeDropdownMenu()
        setupLanguage()
        
        if comingfrom == .RightMenu {
            if AppSettings.shared.selectedLanguage == .arabic {
                contactTitleLabel.text = "الإبلاغ عن تطبيق"
                self.selectTypeButton.setTitle("شكوى", for: .normal)
            } else {
                contactTitleLabel.text = titleText ?? "Report an app"
                self.selectTypeButton.setTitle("Complaint", for: .normal)
            }
            self.selectTypeButton.isEnabled = false
            self.typeLabel.isHidden = true
            self.selectTypeButton.isHidden = true
            self.chevronImgView.isHidden = true
            self.typeLabel.heightAnchor.constraint(equalToConstant: 0).isActive = true
            self.selectTypeButton.heightAnchor.constraint(equalToConstant: 0).isActive = true
            self.chevronImgView.heightAnchor.constraint(equalToConstant: 0).isActive = true
        } else {
            contactTitleLabel.text = AppSettings.shared.selectedLanguage == .arabic ? "اتصل بنا" : "Contact Us"
        }
        contactTitleLabel.textAlignment = .center
        
    }
    
    func setupContactUsTypeDropdownMenu() {
        let starOptions: [String]
        if AppSettings.shared.selectedLanguage == .arabic {
            starOptions = ["ملاحظات", "استفسار", "شكوى"]
        } else {
            starOptions = ["Feedback", "Enquiry", "Complaint"]
        }
        
        var actions: [UIAction] = []
        
        for title in starOptions {
            let action = UIAction(title: title, handler: { [weak self] _ in
                let attributedTitle = NSAttributedString(
                    string: title,
                    attributes: [
                        .font: UIFont.systemFont(ofSize: 15, weight: .medium)
                    ]
                )
                self?.selectTypeButton.setAttributedTitle(attributedTitle, for: .normal)
                self?.type = title
            })
            actions.append(action)
        }
        
        let menuTitle = AppSettings.shared.selectedLanguage == .arabic ? "اختر الموضوع" : "Select Subject"
        let menu = UIMenu(title: menuTitle, children: actions)
        
        selectTypeButton.showsMenuAsPrimaryAction = true
        selectTypeButton.menu = menu
        
        let defaultTitle = AppSettings.shared.selectedLanguage == .arabic ? "اختر الموضوع" : "Select Subject"
        let attributedTitle = NSAttributedString(
            string: defaultTitle,
            attributes: [
                .font: UIFont.systemFont(ofSize: 15, weight: .medium)
            ]
        )
        selectTypeButton.setAttributedTitle(attributedTitle, for: .normal)
    }
    
    
    @IBAction func submitButtonAction(_ sender: Any) {
        // Validate subject
        guard let subject = selectTypeButton.titleLabel?.text,
              !subject.isEmpty, subject.lowercased() != "select subject" else {
            showAlert("Please select subject")
            return
        }
        // Validate message
        guard let message = enterMessageTextView.text,
              !message.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            showAlert("Please enter message")
            return
        }
        
        showLoader()
        hotelViewModel.onReporAnAppSucess = { response in
            self.hideLoader()
            self.showAlert(title: "Success", message: response.message, OkButtonTitle: "Ok", onOK: {
                self.goToHomeTab()
            })
        }
        
        hotelViewModel.onReviewError = { error in
            self.hideLoader()
            self.showAlert(error)
        }
        
        // API call
        
        if comingfrom == .TabBar  || comingfrom == .RightMenu{
            //pass type,subject,message,username,email ans phone from textfield           
            if comingfrom == .RightMenu {
                type = "Complaint"
            }
            hotelViewModel.submitReporAnApp(type: type, subject: subject, message: message, hotelId: "", userName: enterYourNameTF.text ?? "", UserEmail: enterEmailTF.text ?? "", userPhone: enterPhoneNumberTF.text ?? "")
            
            
        } else if comingfrom == .HotelDetail {
            
            hotelViewModel.submitReporAnApp(type: type, subject: subject, message: message, hotelId: "", userName: enterYourNameTF.text ?? "", UserEmail: enterEmailTF.text ?? "", userPhone: enterPhoneNumberTF.text ?? "")
            
        }else if comingfrom == .BookingHistory{
            guard let user = UserSessionManager.getUser() else {
                return
            }
            hotelViewModel.submitReporAnApp(type: type, subject: subject, message: message, hotelId: hotelID, userName: user.name, UserEmail: user.email, userPhone: user.mobile
            )
        }
    }
    
    
    @IBAction func dismissButton(_ sender: Any) {
        if comingfrom == .RightMenu || comingfrom == .HotelDetail{
            self.dismiss(animated: true)
        }else{
            UIApplication.topViewController()?.dismissPopup(ofType: ReportAnAppVC.self)
        }
    }
}

extension ReportAnAppVC {
    func setupLanguage() {
        if AppSettings.shared.selectedLanguage == .arabic {
            subjectLabel.text = "الموضوع"
            typeLabel.text = "النوع"
            messageLabel.text = "الرسالة"
            yourNameLabel.text = "اسمك"
            yourEmailLabel.text = "بريدك الإلكتروني"
            phoneNoLabel.text = "رقم الهاتف"
            submitButton.setTitle("إرسال", for: .normal)
            
        } else {
            subjectLabel.text = "Subject"
            typeLabel.text = "Type"
            messageLabel.text = "Message"
            yourNameLabel.text = "Your Name"
            yourEmailLabel.text = "Your Email"
            phoneNoLabel.text = "Phone"
            submitButton.setTitle("Send", for: .normal)
            
        }
        
        subjectLabel.textAlignment = .left
        typeLabel.textAlignment = .left
        messageLabel.textAlignment = .left
        contactTitleLabel.textAlignment = .left
        yourNameLabel.textAlignment = .left
        yourEmailLabel.textAlignment = .left
        phoneNoLabel.textAlignment = .left
        enterMessageTextView.textAlignment = .left
        enterSubjectTF.textAlignment = .left
        enterYourNameTF.textAlignment = .left
        enterEmailTF.textAlignment = .left
        enterPhoneNumberTF.textAlignment = .left
    }
    
}
