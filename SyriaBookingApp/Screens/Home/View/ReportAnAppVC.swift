//
//  ReportAnAppVC.swift
//  SyriaBookingApp
//
//  Created by toqsoft on 04/09/25.
//

import UIKit

class ReportAnAppVC: UIViewController {
    
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
        topView.layer.cornerRadius = 10
        topView.addBottomShadow()
        setupContactUsTypeDropdownMenu()
        if comingfrom == .RightMenu {
            contactTitleLabel.text = titleText ?? "Report an app"
            
            self.selectTypeButton.setTitle("Complaint", for: .normal)
            self.selectTypeButton.isEnabled = false
            self.typeLabel.isHidden = true
            self.selectTypeButton.isHidden = true
            self.chevronImgView.isHidden = true
            
            self.typeLabel.heightAnchor.constraint(equalToConstant: 0).isActive = true
            self.selectTypeButton.heightAnchor.constraint(equalToConstant: 0).isActive = true
            self.chevronImgView.heightAnchor.constraint(equalToConstant: 0).isActive = true
        } else {
            contactTitleLabel.text = "Contact Us"
        }
    }
    
    func setupContactUsTypeDropdownMenu() {
        let starOptions: [String] = ["Feedback","Enquiry","Complaint"]
        
        var actions: [UIAction] = []
        
        for title in starOptions {
            let action = UIAction(title: title, handler: { [weak self] _ in
                self?.selectTypeButton.setTitle(title, for: .normal)
                self?.type = title
            })
            actions.append(action)
        }
        
        let menu = UIMenu(title: "Select Subject", children: actions)
        
        selectTypeButton.showsMenuAsPrimaryAction = true
        selectTypeButton.menu = menu
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
                if self.comingfrom == .RightMenu || self.comingfrom == .HotelDetail{
                    self.dismiss(animated: true)
                }else{
                    self.dismissPopup()
//                    UIApplication.topViewController()?.dismissPopup(ofType: ReportAnAppVC.self)
                }
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
            
            
        }else if comingfrom == .HotelDetail {
           
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
