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
    @IBOutlet weak var careerApplicationTitleLabel: UILabel!
    @IBOutlet weak var fullNameTitleLabel: UILabel!
    @IBOutlet weak var emailTitleLabel: UILabel!
    @IBOutlet weak var phoneTitleLabel: UILabel!
    @IBOutlet weak var cityTitleLabel: UILabel!
    @IBOutlet weak var positionAppliedTitleLabel: UILabel!
    @IBOutlet weak var coverMessageTitleLabel: UILabel!
    @IBOutlet weak var cvOrResumeTitleLabel: UILabel!
    @IBOutlet weak var maxSizeTitleLabel: UILabel!
    
    var viewModel = CareerApplicationViewModel()
    private var selectedFileBase64: String?
    private var captchaAnswer: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add language change notification observer
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateTexts),
            name: .languageChanged,
            object: nil
        )
        
        generateCaptcha()
        hideKeyboardWhenTappedAround()
        updateTexts()
    }
    
    @objc func updateTexts() {
        let lang = AppSettings.shared.selectedLanguage
        
        // Set fonts
        let semibold13 = UIFont.systemFont(ofSize: 13, weight: .semibold)
        let semibold15 = UIFont.systemFont(ofSize: 15, weight: .semibold)
        
        if lang == .arabic {
            // Title
            careerApplicationTitleLabel.text = "تقديم طلب وظيفة"
            
            // Field labels
            fullNameTitleLabel.text = "الاسم الكامل *"
            emailTitleLabel.text = "البريد الإلكتروني *"
            phoneTitleLabel.text = "رقم الهاتف"
            cityTitleLabel.text = "المدينة"
            positionAppliedTitleLabel.text = "الوظيفة المتقدم لها"
            coverMessageTitleLabel.text = "رسالة تغطية"
            cvOrResumeTitleLabel.text = "السيرة الذاتية (PDF, DOC, DOCX)"
            maxSizeTitleLabel.text = "الحد الأقصى: 5 ميجابايت. الملفات المسموحة: .pdf, .doc, .docx"
            
            // Placeholders
            fullNameLabel.placeholder = "أدخل اسمك الكامل"
            emailIdLabel.placeholder = "أدخل بريدك الإلكتروني"
            phoneNumberLabel.placeholder = "أدخل رقم هاتفك"
            cityLabel.placeholder = "أدخل مدينتك"
            positionAppliedTF.placeholder = "أدخل الوظيفة المتقدم لها"
            enterCaptchaTF.placeholder = "أدخل الإجابة"
            
            // Selected file label
            if selectedFileLabel.text == "no file selected" || selectedFileLabel.text == "لم يتم اختيار ملف" {
                selectedFileLabel.text = "لم يتم اختيار ملف"
            }
            
            // Buttons
            let chooseFileAttributed = NSAttributedString(
                string: "اختر ملف",
                attributes: [.font: semibold13, .foregroundColor: UIColor.white]
            )
            chooseFileButton.setAttributedTitle(chooseFileAttributed, for: .normal)
            
            let submitAttributed = NSAttributedString(
                string: "تقديم الطلب",
                attributes: [.font: semibold15, .foregroundColor: UIColor.white]
            )
            submitApplicationButton.setAttributedTitle(submitAttributed, for: .normal)
            
            let closeAttributed = NSAttributedString(
                string: "إغلاق",
                attributes: [.font: semibold15, .foregroundColor: UIColor.white]
            )
            closeButton.setAttributedTitle(closeAttributed, for: .normal)
            
            // Text alignment for Arabic
            fullNameLabel.textAlignment = .right
            emailIdLabel.textAlignment = .right
            phoneNumberLabel.textAlignment = .right
            cityLabel.textAlignment = .right
            positionAppliedTF.textAlignment = .right
            coverMessageTextView.textAlignment = .right
            enterCaptchaTF.textAlignment = .right
            selectedFileLabel.textAlignment = .right
        } else {
            // Title
            careerApplicationTitleLabel.text = "Career Application"
            
            // Field labels
            fullNameTitleLabel.text = "Full Name *"
            emailTitleLabel.text = "Email *"
            phoneTitleLabel.text = "Phone"
            cityTitleLabel.text = "City"
            positionAppliedTitleLabel.text = "Position Applied For"
            coverMessageTitleLabel.text = "Cover Message"
            cvOrResumeTitleLabel.text = "CV / Resume (PDF, DOC, DOCX)"
            maxSizeTitleLabel.text = "Max size: 5 MB. Allowed: .pdf, .doc, .docx"
            
            // Placeholders
            fullNameLabel.placeholder = "Enter your full name"
            emailIdLabel.placeholder = "Enter your email"
            phoneNumberLabel.placeholder = "Enter your phone number"
            cityLabel.placeholder = "Enter your city"
            positionAppliedTF.placeholder = "Enter position applied for"
            enterCaptchaTF.placeholder = "Enter answer"
            
            // Selected file label
            if selectedFileLabel.text == "لم يتم اختيار ملف" || selectedFileLabel.text == "no file selected" {
                selectedFileLabel.text = "no file selected"
            }
            
            // Buttons
            let chooseFileAttributed = NSAttributedString(
                string: "Choose File",
                attributes: [.font: semibold13, .foregroundColor: UIColor.white]
            )
            chooseFileButton.setAttributedTitle(chooseFileAttributed, for: .normal)
            
            let submitAttributed = NSAttributedString(
                string: "Submit Application",
                attributes: [.font: semibold15, .foregroundColor: UIColor.white]
            )
            submitApplicationButton.setAttributedTitle(submitAttributed, for: .normal)
            
            let closeAttributed = NSAttributedString(
                string: "Close",
                attributes: [.font: semibold15, .foregroundColor: UIColor.white]
            )
            closeButton.setAttributedTitle(closeAttributed, for: .normal)
            
            // Text alignment for English
            fullNameLabel.textAlignment = .left
            emailIdLabel.textAlignment = .left
            phoneNumberLabel.textAlignment = .left
            cityLabel.textAlignment = .left
            positionAppliedTF.textAlignment = .left
            coverMessageTextView.textAlignment = .left
            enterCaptchaTF.textAlignment = .left
            selectedFileLabel.textAlignment = .left
        }
    }
    
    private func generateCaptcha() {
        let num1 = Int.random(in: 1...9)
        let num2 = Int.random(in: 1...9)
        captchaAnswer = num1 + num2
        
        let lang = AppSettings.shared.selectedLanguage
        if lang == .arabic {
            captchaLabel.text = "\(num1) + \(num2) = ؟"
        } else {
            captchaLabel.text = "\(num1) + \(num2) = ?"
        }
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
        let lang = AppSettings.shared.selectedLanguage
        
        guard let name = fullNameLabel.text, !name.isEmpty else {
            showAlert(lang == .arabic ? "الرجاء إدخال اسمك" : "Please enter your name")
            return
        }
        
        guard let email = emailIdLabel.text, !email.isEmpty else {
            showAlert(lang == .arabic ? "الرجاء إدخال بريدك الإلكتروني" : "Please enter your email")
            return
        }
        
        if !isValidEmail(email){
            emailIdLabel.layer.borderColor = UIColor.red.cgColor
            emailIdLabel.layer.borderWidth = 0.5
            showAlert(lang == .arabic ? "الرجاء إدخال بريد إلكتروني صحيح" : "Please enter a valid email address")
            return
        }

        guard let enteredCaptcha = enterCaptchaTF.text,
              let enteredValue = Int(enteredCaptcha),
              enteredValue == captchaAnswer else {
            showAlert(lang == .arabic ? "رمز التحقق غير صحيح" : "Captcha does not match")
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
                    title: lang == .arabic ? "تم بنجاح" : "Success",
                    message: lang == .arabic ?
                        "شكراً لتقديمك. استلم فريق الموارد البشرية تفاصيلك وسيتواصل معك إذا كان ملفك الشخصي مناسباً لمتطلباتنا." :
                        "Thank you for your application. Our HR team has received your details and will contact you if your profile matches our requirements.",
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
            CvFile: cvFile
        )
    }
  
    @IBAction func closeButtonAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension CareerApplicationVC: UIDocumentPickerDelegate {

    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let fileURL = urls.first else { return }

        let allowedExtensions = ["pdf", "doc", "docx"]
        let fileExtension = fileURL.pathExtension.lowercased()
        
        let lang = AppSettings.shared.selectedLanguage

        guard allowedExtensions.contains(fileExtension) else {
            showAlert(lang == .arabic ? "الملفات المسموحة: PDF, DOC, DOCX فقط" : "Only PDF, DOC, DOCX files are allowed")
            return
        }

        do {
            let data = try Data(contentsOf: fileURL)
            let fileSizeMB = Double(data.count) / (1024 * 1024)

            guard fileSizeMB <= 5 else {
                showAlert(lang == .arabic ? "حجم الملف يجب أن يكون أقل من 5 ميجابايت" : "File size must be less than 5 MB")
                return
            }

            selectedFileBase64 = data.base64EncodedString()
            selectedFileLabel.text = fileURL.lastPathComponent

        } catch {
            showAlert(lang == .arabic ? "غير قادر على قراءة الملف المحدد" : "Unable to read selected file")
        }
    }
}
