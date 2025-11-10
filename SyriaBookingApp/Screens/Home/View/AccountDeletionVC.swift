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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        attachData()
    }
    
    func attachData() {
        if let user = UserSessionManager.getUser() {
            nameTextfield.text = user.name
            emailTextField.text = user.email
            phoneNumberTextField.text = user.mobile
        }
    }
    
    @IBAction func submitDeleteAccountButtonAction(_ sender: UIButton) {
        guard let message = messageTextField.text, !message.isEmpty else {
            showAlert("Please enter a message")
            return
        }
        submitDeleteAccountRequest(message: message)
    }
    
    
    private func submitDeleteAccountRequest(message: String) {
        
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
                        self.showAlert(title:"SyriaBooking", message:"Thanks — we received your deletion request. We will process it within 7 business days.", onOK : {
                            self.goToHomeTab()
                        })
                    } else {
                        self.showAlert("Something went wrong. Please try again later.")
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
