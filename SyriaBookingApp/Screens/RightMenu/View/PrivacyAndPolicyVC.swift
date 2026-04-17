//
//  PrivacyAndPolicyVC.swift
//  SyriaBookingApp
//
//  Created by Hitman on 30/03/26.
//

import UIKit

class PrivacyAndPolicyVC: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var insideScrollView: UIView!
    @IBOutlet weak var lastUpdateLabel: UILabel!
    @IBOutlet weak var weRespectYourPrivacyLabel: UIScrollView!
    @IBOutlet weak var whatInformationView: UIView!
    @IBOutlet weak var oneLabel: UILabel!
    @IBOutlet weak var whatInformationWeCollectLabel: UILabel!
    @IBOutlet weak var whenYouUseSyriaBookingLabel: UILabel!
    @IBOutlet weak var aPersonalDataLabel: UILabel!
    @IBOutlet weak var fullnameLabel: UILabel!
    @IBOutlet weak var emailAddressLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var bookingReferenceLabel: UILabel!
    @IBOutlet weak var specialRequestLabel: UILabel!
    @IBOutlet weak var weDoNotCollectCreditCardLabel: UILabel!
    @IBOutlet weak var technicalDataLabel: UILabel!
    @IBOutlet weak var iPAddressLabel: UILabel!
    @IBOutlet weak var browserTypeVersionLabel: UILabel!
    @IBOutlet weak var deviceTypeLabel: UILabel!
    @IBOutlet weak var locationPermittedBrowserLabel: UILabel!
    @IBOutlet weak var pagesVisitedInteractionLabel: UILabel!
    @IBOutlet weak var howWeUseInformationView: UIView!
    @IBOutlet weak var twolabel: UILabel!
    @IBOutlet weak var howWeUseYourInformationLabel: UILabel!
    @IBOutlet weak var weUseYourDataToLabel: UILabel!
    @IBOutlet weak var processAndConfirmYourBookingsLabel: UILabel!
    @IBOutlet weak var sendBookingConfirmationsLabel: UILabel!
    @IBOutlet weak var improveUserExperienceLabel: UILabel!
    @IBOutlet weak var respondToCustomerServiceLabel: UILabel!
    @IBOutlet weak var preventFraudOrMisuseLabel: UILabel!
    @IBOutlet weak var sendServiceUpdateOrOffersLabel: UILabel!
    @IBOutlet weak var howWeShareYourInformationView: UIView!
    @IBOutlet weak var threeLabel: UILabel!
    @IBOutlet weak var howWeShareYourInformationLabel: UILabel!
    @IBOutlet weak var weOnlyShareYourInformationLabel: UILabel!
    @IBOutlet weak var theHotelYouHaveBookedWithLabel: UILabel!
    @IBOutlet weak var ourInternalCustomerLabel: UILabel!
    @IBOutlet weak var legalAuthoritiesRequiredLabel: UILabel!
    @IBOutlet weak var dataSecurityView: UIView!
    @IBOutlet weak var fourLabel: UILabel!
    @IBOutlet weak var dataSecurityLabel: UILabel!
    @IBOutlet weak var weImplementAppropriateTechnicalLabel: UILabel!
    @IBOutlet weak var encryptedConnectionLabel: UILabel!
    @IBOutlet weak var secureDatabaseStorageLabel: UILabel!
    @IBOutlet weak var limitedAccessToAuthorizedLabel: UILabel!
    @IBOutlet weak var dataRetentionView: UIView!
    @IBOutlet weak var fiveLabel: UILabel!
    @IBOutlet weak var dataRetentionLabel: UILabel!
    @IBOutlet weak var weRetainYourPersonalDataLabel: UILabel!
    @IBOutlet weak var youMayRequestDeletionYourDataLabel: UILabel!
    @IBOutlet weak var cookiePolicyView: UIView!
    @IBOutlet weak var sixLabel: UILabel!
    @IBOutlet weak var cookiePolicyLabel: UILabel!
    @IBOutlet weak var whatAreCookiesLabel: UILabel!
    @IBOutlet weak var cookiesAreSmallTextFilesLabel: UILabel!
    @IBOutlet weak var typeOfCookiesWeUseLabel: UILabel!
    @IBOutlet weak var essentialCookiesLabel: UILabel!
    @IBOutlet weak var performanceCookiesLabel: UILabel!
    @IBOutlet weak var functionalityCookiesLabel: UILabel!
    @IBOutlet weak var analyticsCookiesLabel: UILabel!
    @IBOutlet weak var managingCookiesLabel: UILabel!
    @IBOutlet weak var youCanmanageOrDisableCookiesLabel: UILabel!
    @IBOutlet weak var internationalUserView: UIView!
    @IBOutlet weak var sevenLabel: UILabel!
    @IBOutlet weak var internationalUsersLabel: UILabel!
    @IBOutlet weak var syriaBookingIsBasedinSyriaPlatformLabel: UILabel!
    @IBOutlet weak var yourRightsView: UIView!
    @IBOutlet weak var eightLabel: UILabel!
    @IBOutlet weak var yourRightsLabel: UILabel!
    @IBOutlet weak var youHavetheRightToLabel: UILabel!
    @IBOutlet weak var accessYourPersonalDataLabel: UILabel!
    @IBOutlet weak var requestCorrectionOfInaccurateDataLabel: UILabel!
    @IBOutlet weak var requestDeletionOfYourDataLabel: UILabel!
    @IBOutlet weak var withDrawYourConsentMarketingLabel: UILabel!
    @IBOutlet weak var lodgeComplaintWithADataLabel: UILabel!
    @IBOutlet weak var contactUsView: UIView!
    @IBOutlet weak var nineLabel: UILabel!
    @IBOutlet weak var contactUsLabel: UILabel!
    @IBOutlet weak var forQuestionsRequestsLabel: UILabel!
    @IBOutlet weak var emailTitleLabel: UILabel!
    @IBOutlet weak var emailButton: UIButton!
    @IBOutlet weak var needHelpView: UIView!
    @IBOutlet weak var needHelpWithPrivacyQuestionsLabel: UILabel!
    @IBOutlet weak var contactSupportButton: UIButton!
    @IBOutlet weak var thankyouForVisitingLabel: UILabel!
    @IBOutlet weak var byUsingourWebsiteServicsLabel: UILabel!
    @IBOutlet weak var followLinksView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSocialMediaView()
        setupCardStyles()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateShadowPaths()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupAppNavigationBar()
    }
    
    private func setupCardStyles() {
        let cardViews = [
            whatInformationView,
            howWeUseInformationView,
            howWeShareYourInformationView,
            dataSecurityView,
            dataRetentionView,
            cookiePolicyView,
            internationalUserView,
            yourRightsView,
            contactUsView
        ]
        
        for cardView in cardViews {
            if let view = cardView {
                applyShadow(to: view)
            }
        }
    }
    
    private func applyShadow(to view: UIView) {
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 8
        
        if view.backgroundColor == nil || view.backgroundColor == .clear {
            view.backgroundColor = .white
        }
    }
    
    private func updateShadowPaths() {
        let cardViews = [
            whatInformationView,
            howWeUseInformationView,
            howWeShareYourInformationView,
            dataSecurityView,
            dataRetentionView,
            cookiePolicyView,
            internationalUserView,
            yourRightsView,
            contactUsView
        ]
        
        for cardView in cardViews {
            if let view = cardView {
                view.layer.shadowPath = UIBezierPath(
                    roundedRect: view.bounds,
                    cornerRadius: view.layer.cornerRadius
                ).cgPath
            }
        }
    }
    
    private func setupSocialMediaView() {
        let nib = UINib(nibName: "SocialMedia", bundle: nil)
        guard let socialView = nib.instantiate(withOwner: nil, options: nil).first as? SocialMediaView else {
            return
        }
        
        followLinksView.addSubview(socialView)
        
        socialView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            socialView.topAnchor.constraint(equalTo: followLinksView.topAnchor),
            socialView.bottomAnchor.constraint(equalTo: followLinksView.bottomAnchor),
            socialView.leadingAnchor.constraint(equalTo: followLinksView.leadingAnchor),
            socialView.trailingAnchor.constraint(equalTo: followLinksView.trailingAnchor)
        ])
    }
    
    private func makePhoneCall(to phoneNumber: String, isEmergency: Bool = false) {
        guard let testURL = URL(string: "tel:112"), UIApplication.shared.canOpenURL(testURL) else {
            showPhoneNumberForCopy(phoneNumber: phoneNumber)
            return
        }
        
        let formattedNumber: String
        if phoneNumber.hasPrefix("+") {
            formattedNumber = phoneNumber
        } else {
            formattedNumber = phoneNumber.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        }
        
        guard let url = URL(string: "tel:\(formattedNumber)") else {
            print("Invalid phone number URL")
            showPhoneCallError(phoneNumber: phoneNumber)
            return
        }
        
        print("Attempting to call: \(formattedNumber)")
        
        if isEmergency {
            showEmergencyCallConfirmation(for: formattedNumber, url: url)
        } else {
            showPhoneCallConfirmation(for: formattedNumber, url: url)
        }
    }
    
    private func showPhoneNumberForCopy(phoneNumber: String) {
        let alertTitle = AppSettings.shared.selectedLanguage == .arabic ? "رقم الهاتف" : "Phone Number"
        let alertMessage = AppSettings.shared.selectedLanguage == .arabic ?
        "هذا الجهاز لا يمكنه إجراء المكالمات. يمكنك نسخ الرقم \(phoneNumber) للاتصال يدوياً." :
        "This device cannot make phone calls. You can copy the number \(phoneNumber) to call manually."
        let copyTitle = AppSettings.shared.selectedLanguage == .arabic ? "نسخ الرقم" : "Copy Number"
        let cancelTitle = AppSettings.shared.selectedLanguage == .arabic ? "إلغاء" : "Cancel"
        
        let alert = UIAlertController(
            title: alertTitle,
            message: alertMessage,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: copyTitle, style: .default) { _ in
            UIPasteboard.general.string = phoneNumber
            self.showCopySuccessMessage()
        })
        
        alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel))
        
        present(alert, animated: true)
    }
    
    private func showCopySuccessMessage() {
        let message = AppSettings.shared.selectedLanguage == .arabic ?
        "تم نسخ الرقم بنجاح" :
        "Number copied successfully"
        
        let alert = UIAlertController(
            title: nil,
            message: message,
            preferredStyle: .alert
        )
        
        present(alert, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            alert.dismiss(animated: true)
        }
    }
    
    private func showEmergencyCallConfirmation(for phoneNumber: String, url: URL) {
        let alertTitle = AppSettings.shared.selectedLanguage == .arabic ? "اتصال طارئ" : "Emergency Call"
        let alertMessage = AppSettings.shared.selectedLanguage == .arabic ?
        "هل تريد الاتصال برقم الطوارئ \(phoneNumber)؟" :
        "Do you want to call emergency number \(phoneNumber)?"
        let cancelTitle = AppSettings.shared.selectedLanguage == .arabic ? "إلغاء" : "Cancel"
        let callTitle = AppSettings.shared.selectedLanguage == .arabic ? "اتصال طارئ" : "Emergency Call"
        
        let alert = UIAlertController(
            title: alertTitle,
            message: alertMessage,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel))
        alert.addAction(UIAlertAction(title: callTitle, style: .destructive) { _ in
            self.initiateCall(url: url, phoneNumber: phoneNumber)
        })
        
        present(alert, animated: true)
    }
    
    private func showPhoneCallConfirmation(for phoneNumber: String, url: URL) {
        let alertTitle = AppSettings.shared.selectedLanguage == .arabic ? "الاتصال" : "Call"
        let alertMessage = AppSettings.shared.selectedLanguage == .arabic ?
        "هل تريد الاتصال بـ \(phoneNumber)؟" :
        "Do you want to call \(phoneNumber)?"
        let cancelTitle = AppSettings.shared.selectedLanguage == .arabic ? "إلغاء" : "Cancel"
        let callTitle = AppSettings.shared.selectedLanguage == .arabic ? "اتصال" : "Call"
        
        let alert = UIAlertController(
            title: alertTitle,
            message: alertMessage,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel))
        alert.addAction(UIAlertAction(title: callTitle, style: .default) { _ in
            self.initiateCall(url: url, phoneNumber: phoneNumber)
        })
        
        present(alert, animated: true)
    }
    
    private func initiateCall(url: URL, phoneNumber: String) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            UIApplication.shared.open(url, options: [:]) { success in
                if success {
                    print("Call initiated successfully to: \(phoneNumber)")
                } else {
                    print("Failed to initiate call to: \(phoneNumber)")
                    self.showPhoneCallError(phoneNumber: phoneNumber)
                }
            }
        }
    }
    
    private func showPhoneCallError(phoneNumber: String) {
        let alertTitle = AppSettings.shared.selectedLanguage == .arabic ? "خطأ في الاتصال" : "Call Error"
        let alertMessage = AppSettings.shared.selectedLanguage == .arabic ?
        "لا يمكن إجراء المكالمة إلى \(phoneNumber). تأكد من أن جهازك يمكنه إجراء المكالمات." :
        "Cannot make call to \(phoneNumber). Please ensure your device can make phone calls."
        
        let alert = UIAlertController(
            title: alertTitle,
            message: alertMessage,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    // MARK: - Email Helper Methods
    
    private func sendEmail(to emailAddress: String, subject: String = "") {
        var emailURLString = "mailto:\(emailAddress)"
        
        if !subject.isEmpty {
            let encodedSubject = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            emailURLString += "?subject=\(encodedSubject)"
        }
        
        guard let url = URL(string: emailURLString) else {
            print("Invalid email URL")
            showEmailError()
            return
        }
        
        print("Attempting to send email to: \(emailAddress)")
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:]) { success in
                if success {
                    print("Email app opened successfully")
                } else {
                    print("Failed to open email app")
                    self.showEmailError()
                }
            }
        } else {
            print("Cannot open email app")
            showEmailError()
        }
    }
    
    private func showEmailError() {
        let alertTitle = AppSettings.shared.selectedLanguage == .arabic ? "لا يمكن إرسال بريد إلكتروني" : "Cannot Send Email"
        let alertMessage = AppSettings.shared.selectedLanguage == .arabic ?
        "تطبيق البريد الإلكتروني غير مثبت على هذا الجهاز أو لم يتم تكوينه." :
        "Mail app is not configured on this device."
        
        let alert = UIAlertController(
            title: alertTitle,
            message: alertMessage,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    @IBAction func emailButtonAction(_ sender: Any) {
        let subject = AppSettings.shared.selectedLanguage == .arabic ?
        "استفسار حول سياسة الخصوصية" : "Privacy Policy Inquiry"
        sendEmail(to: "careers@syriabooking.sy", subject: subject)
    }
    
    @IBAction func contactSupportButtonAction(_ sender: Any) {
        makePhoneCall(to: "+963123456789", isEmergency: false)
    }
}
