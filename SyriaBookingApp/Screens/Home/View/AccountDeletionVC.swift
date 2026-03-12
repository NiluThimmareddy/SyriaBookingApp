//
//  AccountDeletionVC.swift
//  SyriaBookingApp
//
//  Created by toqsoft on 13/10/25.

import UIKit

class AccountDeletionVC: UIViewController {
    
    @IBOutlet weak var SubjectTextField: UITextField!
    @IBOutlet weak var messageTextField: UITextView!
    @IBOutlet weak var nameTextfield: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var accountDeletionTitleLabel: UILabel!
    @IBOutlet weak var subjectTitleLabel: UILabel!
    @IBOutlet weak var messageTitleLabel: UILabel!
    @IBOutlet weak var nameTitleLabel: UILabel!
    @IBOutlet weak var emailTitleLabel: UILabel!
    @IBOutlet weak var phoneNumberTitleLabel: UILabel!
    @IBOutlet weak var sendRequestTitleButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenTappedAround()
        attachData()
        updateTexts()
    }
    
    @objc func updateTexts() {
        let lang = AppSettings.shared.selectedLanguage
        
        let bold17Font = UIFont.boldSystemFont(ofSize: 17)
        
        if lang == .arabic {
            accountDeletionTitleLabel.text = "حذف الحساب"
            subjectTitleLabel.text = "الموضوع"
            messageTitleLabel.text = "الرسالة"
            nameTitleLabel.text = "الاسم"
            emailTitleLabel.text = "البريد الإلكتروني"
            phoneNumberTitleLabel.text = "رقم الهاتف"
            SubjectTextField.text = "طلب حذف الحساب"
            
            let sendRequestAttributedTitle = NSAttributedString(
                string: "إرسال الطلب",
                attributes: [
                    .font: bold17Font,
                    .foregroundColor: sendRequestTitleButton.titleColor(for: .normal) ?? .white
                ]
            )
            sendRequestTitleButton.setAttributedTitle(sendRequestAttributedTitle, for: .normal)
        } else {
            accountDeletionTitleLabel.text = "Account Deletion"
            subjectTitleLabel.text = "Subject"
            messageTitleLabel.text = "Message"
            nameTitleLabel.text = "Name"
            emailTitleLabel.text = "Email"
            phoneNumberTitleLabel.text = "Phone Number"
            SubjectTextField.text = "Requesting for Deleting account"
            
            let sendRequestAttributedTitle = NSAttributedString(
                string: "Send Request",
                attributes: [
                    .font: bold17Font,
                    .foregroundColor: sendRequestTitleButton.titleColor(for: .normal) ?? .white
                ]
            )
            sendRequestTitleButton.setAttributedTitle(sendRequestAttributedTitle, for: .normal)
        }
    }
    
    func attachData() {
        if let user = UserSessionManager.getUser() {
            nameTextfield.text = user.name
            emailTextField.text = user.email
            phoneNumberTextField.text = user.mobile
        }
    }
    
    @IBAction func submitDeleteAccountButtonAction(_ sender: UIButton) {
        let lang = AppSettings.shared.selectedLanguage
        let enterMessageText = lang == .arabic ? "الرجاء إدخال رسالة" : "Please enter a message"
        
        guard let message = messageTextField.text, !message.isEmpty else {
            showAlert(enterMessageText)
            return
        }
        submitDeleteAccountRequest(message: message)
    }
    
    
    private func submitDeleteAccountRequest(message: String) {
        let lang = AppSettings.shared.selectedLanguage
        let successTitle = lang == .arabic ? "سيريا بوكينغ" : "SyriaBooking"
        let successMessage = lang == .arabic ?
        "شكراً لك — لقد تلقينا طلب الحذف الخاص بك. سنقوم بمعالجته خلال 7 أيام عمل." :
        "Thanks — we received your deletion request. We will process it within 7 business days."
        let errorMessage = lang == .arabic ? "حدث خطأ ما. يرجى المحاولة مرة أخرى لاحقاً." : "Something went wrong. Please try again later."
        
        guard let user = UserSessionManager.getUser() else { return }
        
        let baseURL = "https://docs.google.com/forms/d/e/1FAIpQLSdCgN1fhtcpoyD7yqhQIc3SKukItcUEWwWeLj-ytpH_VHn6mw/formResponse"
        
        // Prepare parameters based on your Google Form field entry IDs
        let params = [
            "entry.201439333": user.name,
            "entry.1046284756": user.email,
            "entry.1750033878": user.mobile,
            "entry.1324659407": message
        ]
        
        // Convert parameters to HTTP body
        let bodyString = params.map { "\($0.key)=\($0.value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")" }
            .joined(separator: "&")
        let bodyData = bodyString.data(using: .utf8)
        
        // Create the request
        guard let url = URL(string: baseURL) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = bodyData
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        // Show a loader if needed
        self.showLoader()
        
        // Perform network request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            DispatchQueue.main.async {
                self.hideLoader()
            }
            
            if let error = error {
                DispatchQueue.main.async {
                    self.showAlert("Error: \(error.localizedDescription)")
                }
                return
            }
            
            // Check HTTP response status
            if let httpResponse = response as? HTTPURLResponse {
                print("Response code: \(httpResponse.statusCode)")
                
                DispatchQueue.main.async {
                    if httpResponse.statusCode == 200 {
                        self.showAlert(title: successTitle, message: successMessage, onOK: {
                            self.goToHomeTab()
                        })
                    } else {
                        self.showAlert(errorMessage)
                    }
                }
            }
        }
        task.resume()
    }
    
    
    @IBAction func dismissButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
}
