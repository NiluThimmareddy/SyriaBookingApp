//
//  SafetyResourceCenterViewController.swift
//  SyriaBookingApp
//
//  Created by Toqsoft on 25/03/26.
//
/*
import UIKit

class SafetyResourceCenterViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var insideScrollView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var safetyImageView: UIImageView!
    @IBOutlet weak var redefindingTravelLabel: UILabel!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var safetyResourceCenterTitleLabel: UILabel!
    @IBOutlet weak var yourSafetyIsOurPriorityLabel: UILabel!
    @IBOutlet weak var yourPeaceOfMindLabel: UILabel!
    @IBOutlet weak var thisSafetyResourceCenterOffersLabel: UILabel!
    @IBOutlet weak var bookingSafetyLabel: UILabel!
    @IBOutlet weak var verifiedHotelsOnlyLabel: UILabel!
    @IBOutlet weak var securePlatformLabel: UILabel!
    @IBOutlet weak var noAdvancedPaymentRequiredLabel: UILabel!
    @IBOutlet weak var hotelsSafetyTitleLabel: UILabel!
    @IBOutlet weak var weEncourageOurHotelLabel: UILabel!
    @IBOutlet weak var dailyRoomCleaningLabel: UILabel!
    @IBOutlet weak var onSiteAvailabilityLabel: UILabel!
    @IBOutlet weak var emergencyContactNumberLabel: UILabel!
    @IBOutlet weak var trainedStaffForGuestLabel: UILabel!
    @IBOutlet weak var healthAndHygieneLabel: UILabel!
    @IBOutlet weak var lookForTheSafetyCertifiedLabel: UILabel!
    @IBOutlet weak var travelResponsibilityTitleLabel: UILabel!
    @IBOutlet weak var toEnsureASafetyExperienceLabel: UILabel!
    @IBOutlet weak var followLocalHealthLabel: UILabel!
    @IBOutlet weak var respectHotelRulesLabel: UILabel!
    @IBOutlet weak var carryProperIDLanel: UILabel!
    @IBOutlet weak var keepEmergencyNumbersLabel: UILabel!
    @IBOutlet weak var emergencyContactsTitleButton: UIButton!
    @IBOutlet weak var policeNumberButton: UIButton!
    @IBOutlet weak var medicalNumberButton: UIButton!
    @IBOutlet weak var emergencyEmailButton: UIButton!
    @IBOutlet weak var travelTipsTitleLabel: UILabel!
    @IBOutlet weak var stickToWellKnownLabel: UILabel!
    @IBOutlet weak var avoidTravellingLateAtNightLabel: UILabel!
    @IBOutlet weak var keepValuablesSecureLabel: UILabel!
    @IBOutlet weak var useHotelSafesLabel: UILabel!
    @IBOutlet weak var shareYourTravelItineraryLabel: UILabel!
    @IBOutlet weak var needMoreHelpTitleLabel: UILabel!
    @IBOutlet weak var callSupportButton: UIButton!
    @IBOutlet weak var emailSupportButton: UIButton!
    @IBOutlet weak var followUsLinksView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSocialMediaView()
        safetyImageView.applyFullLightBlackGradientOverlay()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupAppNavigationBar()
    }
    
    private func setupSocialMediaView() {
        let nib = UINib(nibName: "SocialMedia", bundle: nil)
        guard let socialView = nib.instantiate(withOwner: nil, options: nil).first as? SocialMediaView else {
            return
        }

        followUsLinksView.addSubview(socialView)

        socialView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            socialView.topAnchor.constraint(equalTo: followUsLinksView.topAnchor),
            socialView.bottomAnchor.constraint(equalTo: followUsLinksView.bottomAnchor),
            socialView.leadingAnchor.constraint(equalTo: followUsLinksView.leadingAnchor),
            socialView.trailingAnchor.constraint(equalTo: followUsLinksView.trailingAnchor)
        ])
    }
    
    @IBAction func policeNumberButtonAction(_ sender: Any) {
    }
    
    @IBAction func medicalNumberButtonAction(_ sender: Any) {
    }
    
    @IBAction func emergencyEmailButtonAction(_ sender: Any) {
    }
    
    @IBAction func callSupportButtonAction(_ sender: Any) {
    }
    
    @IBAction func emailSupportButtonAction(_ sender: Any) {
    }
    
}
*/

import UIKit

class SafetyResourceCenterViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var insideScrollView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var safetyImageView: UIImageView!
    @IBOutlet weak var redefindingTravelLabel: UILabel!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var safetyResourceCenterTitleLabel: UILabel!
    @IBOutlet weak var yourSafetyIsOurPriorityLabel: UILabel!
    @IBOutlet weak var yourPeaceOfMindLabel: UILabel!
    @IBOutlet weak var thisSafetyResourceCenterOffersLabel: UILabel!
    @IBOutlet weak var bookingSafetyLabel: UILabel!
    @IBOutlet weak var verifiedHotelsOnlyLabel: UILabel!
    @IBOutlet weak var securePlatformLabel: UILabel!
    @IBOutlet weak var noAdvancedPaymentRequiredLabel: UILabel!
    @IBOutlet weak var hotelsSafetyTitleLabel: UILabel!
    @IBOutlet weak var weEncourageOurHotelLabel: UILabel!
    @IBOutlet weak var dailyRoomCleaningLabel: UILabel!
    @IBOutlet weak var onSiteAvailabilityLabel: UILabel!
    @IBOutlet weak var emergencyContactNumberLabel: UILabel!
    @IBOutlet weak var trainedStaffForGuestLabel: UILabel!
    @IBOutlet weak var healthAndHygieneLabel: UILabel!
    @IBOutlet weak var lookForTheSafetyCertifiedLabel: UILabel!
    @IBOutlet weak var travelResponsibilityTitleLabel: UILabel!
    @IBOutlet weak var toEnsureASafetyExperienceLabel: UILabel!
    @IBOutlet weak var followLocalHealthLabel: UILabel!
    @IBOutlet weak var respectHotelRulesLabel: UILabel!
    @IBOutlet weak var carryProperIDLanel: UILabel!
    @IBOutlet weak var keepEmergencyNumbersLabel: UILabel!
    @IBOutlet weak var emergencyContactsTitleButton: UIButton!
    @IBOutlet weak var policeNumberButton: UIButton!
    @IBOutlet weak var medicalNumberButton: UIButton!
    @IBOutlet weak var emergencyEmailButton: UIButton!
    @IBOutlet weak var travelTipsTitleLabel: UILabel!
    @IBOutlet weak var stickToWellKnownLabel: UILabel!
    @IBOutlet weak var avoidTravellingLateAtNightLabel: UILabel!
    @IBOutlet weak var keepValuablesSecureLabel: UILabel!
    @IBOutlet weak var useHotelSafesLabel: UILabel!
    @IBOutlet weak var shareYourTravelItineraryLabel: UILabel!
    @IBOutlet weak var needMoreHelpTitleLabel: UILabel!
    @IBOutlet weak var callSupportButton: UIButton!
    @IBOutlet weak var emailSupportButton: UIButton!
    @IBOutlet weak var followUsLinksView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSocialMediaView()
        safetyImageView.applyFullLightBlackGradientOverlay()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupAppNavigationBar()
    }
    
    private func setupSocialMediaView() {
        let nib = UINib(nibName: "SocialMedia", bundle: nil)
        guard let socialView = nib.instantiate(withOwner: nil, options: nil).first as? SocialMediaView else {
            return
        }

        followUsLinksView.addSubview(socialView)

        socialView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            socialView.topAnchor.constraint(equalTo: followUsLinksView.topAnchor),
            socialView.bottomAnchor.constraint(equalTo: followUsLinksView.bottomAnchor),
            socialView.leadingAnchor.constraint(equalTo: followUsLinksView.leadingAnchor),
            socialView.trailingAnchor.constraint(equalTo: followUsLinksView.trailingAnchor)
        ])
    }
    
    // MARK: - Phone Call Helper Methods
    
    private func makePhoneCall(to phoneNumber: String, isEmergency: Bool = false) {
        let cleanedNumber = phoneNumber.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        
        guard let url = URL(string: "tel:\(cleanedNumber)") else {
            showPhoneCallError(phoneNumber: phoneNumber)
            return
        }
        
        
        if UIApplication.shared.canOpenURL(url) {
            if isEmergency {
                UIApplication.shared.open(url, options: [:]) { success in
                    if success {
                    } else {
                        self.showPhoneCallError(phoneNumber: phoneNumber)
                    }
                }
            } else {
                showPhoneCallConfirmation(for: cleanedNumber, url: url)
            }
        } else {
            showPhoneCallError(phoneNumber: phoneNumber)
        }
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
            UIApplication.shared.open(url, options: [:]) { success in
                if success {
                } else {
                    self.showPhoneCallError(phoneNumber: phoneNumber)
                }
            }
        })
        
        present(alert, animated: true)
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
                
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:]) { success in
                if success {
                } else {
                    self.showEmailError()
                }
            }
        } else {
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
    
    // MARK: - Button Actions
    
    @IBAction func policeNumberButtonAction(_ sender: Any) {
        makePhoneCall(to: "112", isEmergency: true)
    }
    
    @IBAction func medicalNumberButtonAction(_ sender: Any) {
        makePhoneCall(to: "110", isEmergency: true)
    }
    
    @IBAction func emergencyEmailButtonAction(_ sender: Any) {
        let subject = AppSettings.shared.selectedLanguage == .arabic ?
            "طلب مساعدة طارئة" : "Emergency Assistance Request"
        sendEmail(to: "info@syriabooking.sy", subject: subject)
    }
    
    @IBAction func callSupportButtonAction(_ sender: Any) {
        makePhoneCall(to: "+963123456789", isEmergency: false)
    }
    
    @IBAction func emailSupportButtonAction(_ sender: Any) {
        let subject = AppSettings.shared.selectedLanguage == .arabic ?
            "استفسار عن دعم العملاء" : "Customer Support Inquiry"
        sendEmail(to: "info@syriabooking.sy", subject: subject)
    }
}
