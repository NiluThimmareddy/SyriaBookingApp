//
//  SafetyResourceCenterViewController.swift
//  SyriaBookingApp
//
//  Created by Toqsoft on 25/03/26.

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
        updateTexts()
    }
    
    @objc func updateTexts() {
        let lang = AppSettings.shared.selectedLanguage
        let bold18Font = UIFont.boldSystemFont(ofSize: 18)
        let semibold15Font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        
        if lang == .arabic {
            // Main Labels
            redefindingTravelLabel.text = "إعادة تعريف السفر والضيافة في سوريا"
            safetyResourceCenterTitleLabel.text = "مركز موارد السلامة"
            yourSafetyIsOurPriorityLabel.text = "سلامتك هي أولويتنا"
            yourPeaceOfMindLabel.text = "في SyriaBooking.sy، راحة بالك هي في صميم كل ما نقوم به. نحن نوفر تجربة سفر آمنة ومأمونة ومدروسة بدءاً من الحجز وحتى المغادرة."
            thisSafetyResourceCenterOffersLabel.text = "يقدم مركز موارد السلامة هذا إرشادات أساسية لمساعدتك على السفر بثقة في جميع أنحاء سوريا."
            
            // Booking Safety Section
            bookingSafetyLabel.text = "سلامة الحجز"
            verifiedHotelsOnlyLabel.text = "✓ فنادق موثقة فقط : جميع العقارات المدرجة على منصتنا تخضع لعملية تحقق صارمة قبل النشر"
            securePlatformLabel.text = "✓ منصة آمنة : بياناتك محمية باستخدام معايير التشفير وبروتوكولات الخصوصية المعتمدة في الصناعة"
            noAdvancedPaymentRequiredLabel.text = "✓ لا حاجة للدفع المسبق : مع نظام \"الدفع عند الوصول\"، لا تحتاج إلى إدخال أي تفاصيل دفع عبر الإنترنت"
            
            // Hotels Safety Section
            hotelsSafetyTitleLabel.text = "سلامة الفنادق"
            weEncourageOurHotelLabel.text = "✓ نحن نشجع شركاءنا من الفنادق على تبني والحفاظ على ممارسات السلامة التالية:"
            dailyRoomCleaningLabel.text = "✓ التنظيف والتعقيم اليومي للغرف"
            onSiteAvailabilityLabel.text = "✓ توفير حقائب الإسعافات الأولية في الموقع"
            emergencyContactNumberLabel.text = "✓ معلومات الاتصال في حالات الطوارئ متاحة بسهولة"
            trainedStaffForGuestLabel.text = "✓ موظفون مدربون على سلامة النزلاء والاستجابة للطوارئ"
            healthAndHygieneLabel.text = "✓ بروتوكولات الصحة والنظافة خاصة في المناطق عالية التلامس"
            lookForTheSafetyCertifiedLabel.text = "✓ ابحث عن شارة \"معتمد للسلامة\" على الفنادق التي تبذل جهداً إضافياً"
            
            // Traveler Responsibility Section
            travelResponsibilityTitleLabel.text = "مسؤولية المسافر:"
            toEnsureASafetyExperienceLabel.text = "✓ لضمان تجربة آمنة للجميع:"
            followLocalHealthLabel.text = "✓ اتبع إرشادات الصحة والسلامة والسفر المحلية"
            respectHotelRulesLabel.text = "✓ احترم قواعد الفندق وتعليمات الموظفين"
            carryProperIDLanel.text = "✓ احمل هوية ووثائق السفر الصالحة"
            keepEmergencyNumbersLabel.text = "✓ احتفظ بأرقام الطوارئ في متناول يدك"
            
            // Emergency Contacts Button
            let emergencyTitle = NSAttributedString(
                string: "جهات الاتصال للطوارئ",
                attributes: [.font: bold18Font, .foregroundColor: UIColor.white]
            )
            emergencyContactsTitleButton.setAttributedTitle(emergencyTitle, for: .normal)
            
            // Travel Tips Section
            travelTipsTitleLabel.text = "نصائح السفر"
            stickToWellKnownLabel.text = "✓ التزم بالوجهات والمناطق الفندقية المعروفة"
            avoidTravellingLateAtNightLabel.text = "✓ تجنب السفر في وقت متأخر من الليل في الأماكن غير المألوفة"
            keepValuablesSecureLabel.text = "✓ حافظ على أمان الأشياء الثمينة وتجنب إظهار مبالغ نقدية كبيرة"
            useHotelSafesLabel.text = "✓ استخدم خزائن الفندق كلما أمكن ذلك"
            shareYourTravelItineraryLabel.text = "✓ شارك خط سفرك مع العائلة أو الأصدقاء"
            
            // Need More Help Section
            needMoreHelpTitleLabel.text = "بحاجة إلى مزيد من المساعدة؟"
            
            // Support Buttons
            let callSupportTitle = NSAttributedString(
                string: "اتصل بالدعم",
                attributes: [.font: semibold15Font, .foregroundColor: UIColor.lightGray]
            )
            callSupportButton.setAttributedTitle(callSupportTitle, for: .normal)
            
            let emailSupportTitle = NSAttributedString(
                string: "الدعم عبر البريد الإلكتروني",
                attributes: [.font: semibold15Font, .foregroundColor: UIColor.lightGray]
            )
            emailSupportButton.setAttributedTitle(emailSupportTitle, for: .normal)
            
            // Police, Medical, Emergency buttons
            policeNumberButton.setTitle("شرطة - 112", for: .normal)
            medicalNumberButton.setTitle("إسعاف - 110", for: .normal)
            emergencyEmailButton.setTitle("بريد الطوارئ", for: .normal)
            
        } else {
            // English texts
            redefindingTravelLabel.text = "Redefining travel and hospitality within Syria"
            safetyResourceCenterTitleLabel.text = "Safety Resource Center"
            yourSafetyIsOurPriorityLabel.text = "Your safety is our priority."
            yourPeaceOfMindLabel.text = "At SyriaBooking.sy, your peace of mind is at the heart of everything we do. We provide a safe, secure, and informed travel experience from booking to check-out."
            thisSafetyResourceCenterOffersLabel.text = "This Safety Resource Center offers essential guidance to help you travel confidently across Syria."
            
            // Booking Safety Section
            bookingSafetyLabel.text = "Booking Safety"
            verifiedHotelsOnlyLabel.text = "✓ Verified hotels only : All listed properties on our platform go through a strict verification process before being published"
            securePlatformLabel.text = "✓ Secure Platform : Your data is protected using industry standards encryption and privacy protocols"
            noAdvancedPaymentRequiredLabel.text = "✓ No Advance Payment Required : With our \"Pay on Arrival\" system, you don’t need to enter any payment details online."
            
            // Hotels Safety Section
            hotelsSafetyTitleLabel.text = "Hotels Safety"
            weEncourageOurHotelLabel.text = "✓ We encourage our hotel partners to adopt and maintain the following safety practices:"
            dailyRoomCleaningLabel.text = "✓ Daily room cleaning and sanitization"
            onSiteAvailabilityLabel.text = "✓ On-site availability of first aid kits"
            emergencyContactNumberLabel.text = "✓ Emergency contact information readily available"
            trainedStaffForGuestLabel.text = "✓ Trained staff for guest safety and emergency response"
            healthAndHygieneLabel.text = "✓ Health & hygiene protocols especially for high-contact areas"
            lookForTheSafetyCertifiedLabel.text = "✓ Look for the \"Safety Certified\" badge on hotels that go the extra mile"
            
            // Traveler Responsibility Section
            travelResponsibilityTitleLabel.text = "Traveler Responsibility:"
            toEnsureASafetyExperienceLabel.text = "✓ To ensure a safe experience for everyone:"
            followLocalHealthLabel.text = "✓ Follow local health, safety, and travel guidelines"
            respectHotelRulesLabel.text = "✓ Respect hotel rules and staff instructions"
            carryProperIDLanel.text = "✓ Carry proper ID and travel documents"
            keepEmergencyNumbersLabel.text = "✓ Keep emergency numbers accessible"
            
            // Emergency Contacts Button
            let emergencyTitle = NSAttributedString(
                string: "Emergency Contacts",
                attributes: [.font: bold18Font, .foregroundColor: UIColor.white]
            )
            emergencyContactsTitleButton.setAttributedTitle(emergencyTitle, for: .normal)
            
            // Travel Tips Section
            travelTipsTitleLabel.text = "Travel Tips"
            stickToWellKnownLabel.text = "✓ Stick to well-known destinations and hotel areas"
            avoidTravellingLateAtNightLabel.text = "✓ Avoid traveling late at night in unfamiliar locations"
            keepValuablesSecureLabel.text = "✓ Keep valuables secure and avoid displaying large amounts of cash"
            useHotelSafesLabel.text = "✓ Use hotel safes whenever possible"
            shareYourTravelItineraryLabel.text = "✓ Share your travel itinerary with family or friends"
            
            // Need More Help Section
            needMoreHelpTitleLabel.text = "Need More Help?"
            
            // Support Buttons
            let callSupportTitle = NSAttributedString(
                string: "Call Support",
                attributes: [.font: semibold15Font, .foregroundColor: UIColor.lightGray]
            )
            callSupportButton.setAttributedTitle(callSupportTitle, for: .normal)
            
            let emailSupportTitle = NSAttributedString(
                string: "Email Support",
                attributes: [.font: semibold15Font, .foregroundColor: UIColor.lightGray]
            )
            emailSupportButton.setAttributedTitle(emailSupportTitle, for: .normal)
            
            // Police, Medical, Emergency buttons
            policeNumberButton.setTitle("Police - 112", for: .normal)
            medicalNumberButton.setTitle("Medical - 110", for: .normal)
            emergencyEmailButton.setTitle("Emergency Email", for: .normal)
        }
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
                    if !success {
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
        let lang = AppSettings.shared.selectedLanguage
        let alertTitle = lang == .arabic ? "الاتصال" : "Call"
        let alertMessage = lang == .arabic ?
            "هل تريد الاتصال بـ \(phoneNumber)؟" :
            "Do you want to call \(phoneNumber)?"
        let cancelTitle = lang == .arabic ? "إلغاء" : "Cancel"
        let callTitle = lang == .arabic ? "اتصال" : "Call"
        
        let alert = UIAlertController(
            title: alertTitle,
            message: alertMessage,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel))
        alert.addAction(UIAlertAction(title: callTitle, style: .default) { _ in
            UIApplication.shared.open(url, options: [:]) { success in
                if !success {
                    self.showPhoneCallError(phoneNumber: phoneNumber)
                }
            }
        })
        
        present(alert, animated: true)
    }
    
    private func showPhoneCallError(phoneNumber: String) {
        let lang = AppSettings.shared.selectedLanguage
        let alertTitle = lang == .arabic ? "خطأ في الاتصال" : "Call Error"
        let alertMessage = lang == .arabic ?
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
                if !success {
                    self.showEmailError()
                }
            }
        } else {
            showEmailError()
        }
    }
    
    private func showEmailError() {
        let lang = AppSettings.shared.selectedLanguage
        let alertTitle = lang == .arabic ? "لا يمكن إرسال بريد إلكتروني" : "Cannot Send Email"
        let alertMessage = lang == .arabic ?
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
        let lang = AppSettings.shared.selectedLanguage
        let subject = lang == .arabic ?
            "طلب مساعدة طارئة" : "Emergency Assistance Request"
        sendEmail(to: "info@syriabooking.sy", subject: subject)
    }
    
    @IBAction func callSupportButtonAction(_ sender: Any) {
        makePhoneCall(to: "+963123456789", isEmergency: false)
    }
    
    @IBAction func emailSupportButtonAction(_ sender: Any) {
        let lang = AppSettings.shared.selectedLanguage
        let subject = lang == .arabic ?
            "استفسار عن دعم العملاء" : "Customer Support Inquiry"
        sendEmail(to: "info@syriabooking.sy", subject: subject)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
