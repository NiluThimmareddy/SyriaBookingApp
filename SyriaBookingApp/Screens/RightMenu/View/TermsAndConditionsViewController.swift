//
//  TermsAndConditionsViewController.swift
//  SyriaBookingApp
//
//  Created by Toqsoft on 26/03/26.
//
/*
import UIKit

class TermsAndConditionsViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var insideScrollView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var termsAndConditionsImgView: UIImageView!
    @IBOutlet weak var termsAndConditionsTitleLabel: UILabel!
    @IBOutlet weak var redefineTravelLabel: UILabel!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var theseTermsAndConditionsLabel: UILabel!
    @IBOutlet weak var definitionsTitleLabel: UILabel!
    @IBOutlet weak var platformRefersToSyriaLabel: UILabel!
    @IBOutlet weak var userYouRefersToAnyOneLabel: UILabel!
    @IBOutlet weak var hotelOrPropertyLabel: UILabel!
    @IBOutlet weak var bookingMeansReservationMadeLabel: UILabel!
    @IBOutlet weak var scopeOfOurServiceTitleLabel: UILabel!
    @IBOutlet weak var syriaBookingProvidesLabel: UILabel!
    @IBOutlet weak var facilitiesHotelLabel: UILabel!
    @IBOutlet weak var offerAPayOnArrivalLabel: UILabel!
    @IBOutlet weak var doNotOwnManageLabel: UILabel!
    @IBOutlet weak var allBookingsAreMadeDirectlyLabel: UILabel!
    @IBOutlet weak var bookingPolicyTitleLabel: UILabel!
    @IBOutlet weak var youMayBookRoomsLabel: UILabel!
    @IBOutlet weak var bookingConfirmationisSentLabel: UILabel!
    @IBOutlet weak var paymentIsMadeDirectlyLabel: UILabel!
    @IBOutlet weak var someHotelsMayRequireLabel: UILabel!
    @IBOutlet weak var cancellationModificationTitleLabel: UILabel!
    @IBOutlet weak var mostBookingsCanbeModifiedLabel: UILabel!
    @IBOutlet weak var pleaseReviewSpecificCancellationLabel: UILabel!
    @IBOutlet weak var forChangesCancellationsLabel: UILabel!
    @IBOutlet weak var userResponsibilitiesTitleLabel: UILabel!
    @IBOutlet weak var byUsingthePlatformLabel: UILabel!
    @IBOutlet weak var provideAccurateandHonestLabel: UILabel!
    @IBOutlet weak var abideByRulesAndPoliciesLabel: UILabel!
    @IBOutlet weak var arriveOnTimeForCheckinLabel: UILabel!
    @IBOutlet weak var notUseThePlatformLabel: UILabel!
    @IBOutlet weak var hotelResponsibilitiesTitleLabel: UILabel!
    @IBOutlet weak var provideAccurateDescriptionLabel: UILabel!
    @IBOutlet weak var maintainSafetyCleanlinessLabel: UILabel!
    @IBOutlet weak var honorConfirmedBookingsLabel: UILabel!
    @IBOutlet weak var informSyriaBookingSYLabel: UILabel!
    @IBOutlet weak var liabilityDisclaimerTitleLabel: UILabel!
    @IBOutlet weak var syriaBookingisNotResponsibleForServiceLabel: UILabel!
    @IBOutlet weak var weAreNotLiableForPersonalInjuryLabel: UILabel!
    @IBOutlet weak var ourPlatformAndContentLabel: UILabel!
    @IBOutlet weak var intellectualPropertTitleLabel: UILabel!
    @IBOutlet weak var allContentBrandinglogosLabel: UILabel!
    @IBOutlet weak var privacyTitleLabel: UILabel!
    @IBOutlet weak var weAreCommittedtoProtectingLabel: UILabel!
    @IBOutlet weak var terminationTitleLabel: UILabel!
    @IBOutlet weak var weReserveTheRightLabel: UILabel!
    @IBOutlet weak var governingLawTitleLabel: UILabel!
    @IBOutlet weak var theseTermsAndConditionsGovernedLabel: UILabel!
    @IBOutlet weak var contactInformationTitleLabel: UILabel!
    @IBOutlet weak var forQuestionsAreConcernsLabel: UILabel!
    @IBOutlet weak var emailIDButton: UIButton!
    @IBOutlet weak var phoneNumberButton: UIButton!
    @IBOutlet weak var contactSupportButton: UIButton!
    @IBOutlet weak var followLinksView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSocialMediaView()
        termsAndConditionsImgView.applyFullLightBlackGradientOverlay()
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

        followLinksView.addSubview(socialView)

        socialView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            socialView.topAnchor.constraint(equalTo: followLinksView.topAnchor),
            socialView.bottomAnchor.constraint(equalTo: followLinksView.bottomAnchor),
            socialView.leadingAnchor.constraint(equalTo: followLinksView.leadingAnchor),
            socialView.trailingAnchor.constraint(equalTo: followLinksView.trailingAnchor)
        ])
    }
    
    @IBAction func emailIDButtonAction(_ sender: Any) {
    }
    
    @IBAction func contactSupportButtonAction(_ sender: Any) {
    }
    
}
*/

import UIKit

class TermsAndConditionsViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var insideScrollView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var termsAndConditionsImgView: UIImageView!
    @IBOutlet weak var termsAndConditionsTitleLabel: UILabel!
    @IBOutlet weak var redefineTravelLabel: UILabel!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var theseTermsAndConditionsLabel: UILabel!
    @IBOutlet weak var definitionsTitleLabel: UILabel!
    @IBOutlet weak var platformRefersToSyriaLabel: UILabel!
    @IBOutlet weak var userYouRefersToAnyOneLabel: UILabel!
    @IBOutlet weak var hotelOrPropertyLabel: UILabel!
    @IBOutlet weak var bookingMeansReservationMadeLabel: UILabel!
    @IBOutlet weak var scopeOfOurServiceTitleLabel: UILabel!
    @IBOutlet weak var syriaBookingProvidesLabel: UILabel!
    @IBOutlet weak var facilitiesHotelLabel: UILabel!
    @IBOutlet weak var offerAPayOnArrivalLabel: UILabel!
    @IBOutlet weak var doNotOwnManageLabel: UILabel!
    @IBOutlet weak var allBookingsAreMadeDirectlyLabel: UILabel!
    @IBOutlet weak var bookingPolicyTitleLabel: UILabel!
    @IBOutlet weak var youMayBookRoomsLabel: UILabel!
    @IBOutlet weak var bookingConfirmationisSentLabel: UILabel!
    @IBOutlet weak var paymentIsMadeDirectlyLabel: UILabel!
    @IBOutlet weak var someHotelsMayRequireLabel: UILabel!
    @IBOutlet weak var cancellationModificationTitleLabel: UILabel!
    @IBOutlet weak var mostBookingsCanbeModifiedLabel: UILabel!
    @IBOutlet weak var pleaseReviewSpecificCancellationLabel: UILabel!
    @IBOutlet weak var forChangesCancellationsLabel: UILabel!
    @IBOutlet weak var userResponsibilitiesTitleLabel: UILabel!
    @IBOutlet weak var byUsingthePlatformLabel: UILabel!
    @IBOutlet weak var provideAccurateandHonestLabel: UILabel!
    @IBOutlet weak var abideByRulesAndPoliciesLabel: UILabel!
    @IBOutlet weak var arriveOnTimeForCheckinLabel: UILabel!
    @IBOutlet weak var notUseThePlatformLabel: UILabel!
    @IBOutlet weak var hotelResponsibilitiesTitleLabel: UILabel!
    @IBOutlet weak var provideAccurateDescriptionLabel: UILabel!
    @IBOutlet weak var maintainSafetyCleanlinessLabel: UILabel!
    @IBOutlet weak var honorConfirmedBookingsLabel: UILabel!
    @IBOutlet weak var informSyriaBookingSYLabel: UILabel!
    @IBOutlet weak var liabilityDisclaimerTitleLabel: UILabel!
    @IBOutlet weak var syriaBookingisNotResponsibleForServiceLabel: UILabel!
    @IBOutlet weak var weAreNotLiableForPersonalInjuryLabel: UILabel!
    @IBOutlet weak var ourPlatformAndContentLabel: UILabel!
    @IBOutlet weak var intellectualPropertTitleLabel: UILabel!
    @IBOutlet weak var allContentBrandinglogosLabel: UILabel!
    @IBOutlet weak var privacyTitleLabel: UILabel!
    @IBOutlet weak var weAreCommittedtoProtectingLabel: UILabel!
    @IBOutlet weak var terminationTitleLabel: UILabel!
    @IBOutlet weak var weReserveTheRightLabel: UILabel!
    @IBOutlet weak var governingLawTitleLabel: UILabel!
    @IBOutlet weak var theseTermsAndConditionsGovernedLabel: UILabel!
    @IBOutlet weak var contactInformationTitleLabel: UILabel!
    @IBOutlet weak var forQuestionsAreConcernsLabel: UILabel!
    @IBOutlet weak var emailIDButton: UIButton!
    @IBOutlet weak var phoneNumberButton: UIButton!
    @IBOutlet weak var contactSupportButton: UIButton!
    @IBOutlet weak var followLinksView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSocialMediaView()
        termsAndConditionsImgView.applyFullLightBlackGradientOverlay()
        
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

        followLinksView.addSubview(socialView)

        socialView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            socialView.topAnchor.constraint(equalTo: followLinksView.topAnchor),
            socialView.bottomAnchor.constraint(equalTo: followLinksView.bottomAnchor),
            socialView.leadingAnchor.constraint(equalTo: followLinksView.leadingAnchor),
            socialView.trailingAnchor.constraint(equalTo: followLinksView.trailingAnchor)
        ])
    }
    
    // MARK: - Phone Call Helper Methods
    
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
    
    // MARK: - Button Actions
    
    @IBAction func emailIDButtonAction(_ sender: Any) {
        let subject = AppSettings.shared.selectedLanguage == .arabic ?
            "استفسار حول الشروط والأحكام" : "Terms and Conditions Inquiry"
        sendEmail(to: "info@syriabooking.sy", subject: subject)
    }
    
    @IBAction func contactSupportButtonAction(_ sender: Any) {
        makePhoneCall(to: "+963123456789", isEmergency: false)
    }
}
