//
//  CareerApplicationVC.swift
//  SyriaBookingApp
//
//  Created by Toqsoft on 12/01/26.
//

import UIKit
import UniformTypeIdentifiers

class CareerApplicationVC: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var insideScrollView: UIView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var fullNameLabel: UITextField!
    @IBOutlet weak var emailIdLabel: UITextField!
    @IBOutlet weak var phoneNumberLabel: UITextField!
    @IBOutlet weak var cityLabel: UITextField!
    @IBOutlet weak var positionAppliedTF: UITextField!
    @IBOutlet weak var coverMessageTextView: UITextView!
    @IBOutlet weak var chooseFileButton: UIButton!
    @IBOutlet weak var captchaLabel: UILabel!
    @IBOutlet weak var enterCaptchaTF: UITextField!
    @IBOutlet weak var submitApplicationButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var selectedFileLabel: UILabel!
    
    var viewModel = CareerApplicationViewModel()
    private var selectedFileBase64: String?
    private var captchaAnswer: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        generateCaptcha()
        
        hideKeyboardWhenTappedAround()
    }
    
    private func generateCaptcha() {
        let num1 = Int.random(in: 1...9)
        let num2 = Int.random(in: 1...9)
        captchaAnswer = num1 + num2
        captchaLabel.text = "\(num1) + \(num2) = ?"
    }
    
    
    
    @IBAction func dismissButtonAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func chooseFileButtonAction(_ sender: Any) {
        let types: [UTType] = [.pdf, .data]
        
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: types, asCopy: true)
        picker.delegate = self
        picker.allowsMultipleSelection = false
        present(picker, animated: true)
    }
    
    @IBAction func submitApplicationButtonAction(_ sender: Any) {
        
        guard let name = fullNameLabel.text, !name.isEmpty else {
            showAlert("Please enter your name")
            return
        }
        
        guard let email = emailIdLabel.text, !email.isEmpty else {
            showAlert("Please enter your email")
            return
        }
        
        if !isValidEmail(email){
            emailIdLabel.layer.borderColor = UIColor.red.cgColor
            emailIdLabel.layer.borderWidth = 0.5
            showAlert("Please enter a valid email address")
            return
        }



        guard let enteredCaptcha = enterCaptchaTF.text,
              let enteredValue = Int(enteredCaptcha),
              enteredValue == captchaAnswer else {
            showAlert("Captcha does not match")
            generateCaptcha()
            return
        }
        
        let phoneNumber = phoneNumberLabel.text ?? ""
        let city = cityLabel.text ?? ""
        let cvFile = selectedFileBase64 ?? ""
        let appiedFor = positionAppliedTF.text ?? ""
        let covereMessage = coverMessageTextView.text ?? ""
        
        showLoader()
        viewModel.onSuccess = { [weak self] message in
            print(message)
            DispatchQueue.main.async {
                self?.hideLoader()
                self?.showAlert(
                    title: "Success",
                    message: "Thank you for your application. Our HR team has received your details and will contact you if your profile matches our requirements.",
                    type: .success,
                    onOK: {
                        self?.dismiss(animated: true)
                    }
                )
            }
        }
        
        viewModel.onError = { error in
            self.hideLoader()
            self.showAlert(error)
        }
        
        
        viewModel.SubmitCareerInfo(
            ApplicantName: name,
            ApplicantEmail: email,
            ApplicantPhone: phoneNumber,
            ApplicantCity: city,
            AppliedFor: appiedFor,
            CoverMessage: covereMessage,
            CvFile: cvFile   // Base64 binary string
        )
    }
  
    @IBAction func closeButtonAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
}

extension CareerApplicationVC: UIDocumentPickerDelegate {

    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let fileURL = urls.first else { return }

        let allowedExtensions = ["pdf", "doc", "docx"]
        let fileExtension = fileURL.pathExtension.lowercased()

        guard allowedExtensions.contains(fileExtension) else {
            showAlert("Only PDF, DOC, DOCX files are allowed")
            return
        }

        do {
            let data = try Data(contentsOf: fileURL)
            let fileSizeMB = Double(data.count) / (1024 * 1024)

            guard fileSizeMB <= 5 else {
                showAlert("File size must be less than 5 MB")
                return
            }

            selectedFileBase64 = data.base64EncodedString()
            selectedFileLabel.text = fileURL.lastPathComponent

        } catch {
            showAlert("Unable to read selected file")
        }
    }
}
