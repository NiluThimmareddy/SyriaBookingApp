//
//  TermsAndConditionsViewController.swift
//  SyriaBookingApp
//
//  Created by Toqsoft on 26/03/26.

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
        updateTexts()
    }
    
    @objc func updateTexts() {
        let lang = AppSettings.shared.selectedLanguage
        let bold15Font = UIFont.boldSystemFont(ofSize: 15)
        
        if lang == .arabic {
            termsAndConditionsTitleLabel.text = "الشروط والأحكام"
            redefineTravelLabel.text = "إعادة تعريف السفر والضيافة في سوريا"
            welcomeLabel.text = "مرحباً بكم في SyriaBooking.sy"
            theseTermsAndConditionsLabel.text = "هذه الشروط والأحكام (\"الشروط\") تحكم استخدامك لموقع SyriaBooking.sy وخدماته. من خلال الوصول إلى منصتنا أو استخدامها، فإنك توافق على الامتثال لهذه الشروط بالكامل. إذا كنت لا توافق، فيرجى عدم استخدام خدماتنا."
            
            definitionsTitleLabel.text = "تعريفات:"
            platformRefersToSyriaLabel.text = "✓ \"المنصة\" تشير إلى موقع SyriaBooking.sy والخدمات ذات الصلة."
            userYouRefersToAnyOneLabel.text = "✓ \"المستخدم\"، \"أنت\" يشير إلى أي شخص يتصفح أو يستخدم أو يحجز من خلال SyriaBooking.sy."
            hotelOrPropertyLabel.text = "✓ \"الفندق\" أو \"العقار\" يعني مزود الإقامة المدرج على المنصة."
            bookingMeansReservationMadeLabel.text = "✓ \"الحجز\" يعني حجزاً يتم من خلال SyriaBooking.sy للإقامة."
            
            scopeOfOurServiceTitleLabel.text = "نطاق خدمتنا"
            syriaBookingProvidesLabel.text = "✓ توفر SyriaBooking.sy منصة عبر الإنترنت للمستخدمين لاستعراض ومقارنة وحجز أماكن الإقامة في سوريا. نحن:"
            facilitiesHotelLabel.text = "✓ نسهل اكتشاف الفنادق وحجوزاتها"
            offerAPayOnArrivalLabel.text = "✓ نقدم نموذج \"الدفع عند الوصول\" (لا حاجة للدفع عبر الإنترنت)"
            doNotOwnManageLabel.text = "✓ لا نملك أو ندير أو نشغل أي إقامة مدرجة"
            allBookingsAreMadeDirectlyLabel.text = "✓ جميع الحجوزات تتم مباشرة مع الفندق؛ نحن نعمل فقط كوسيط"
            
            bookingPolicyTitleLabel.text = "سياسة الحجز"
            youMayBookRoomsLabel.text = "✓ يمكنك حجز الغرف عبر الموقع دون أي دفعة مقدمة"
            bookingConfirmationisSentLabel.text = "✓ يتم إرسال تأكيد الحجز عبر البريد الإلكتروني أو الرسائل القصيرة بعد الحجز الناجح"
            paymentIsMadeDirectlyLabel.text = "✓ يتم الدفع مباشرة للفندق عند تسجيل الوصول، نقداً أو حسب طرق الدفع المقبولة في الفندق"
            someHotelsMayRequireLabel.text = "✓ قد تتطلب بعض الفنادق تأكيداً متابعة عبر الهاتف/الرسالة؛ قد يؤدي عدم القيام بذلك إلى الإلغاء"
            
            cancellationModificationTitleLabel.text = "سياسة الإلغاء والتعديل:"
            mostBookingsCanbeModifiedLabel.text = "✓ يمكن تعديل أو إلغاء معظم الحجوزات دون رسوم، ولكن تختلف شروط الإلغاء حسب العقار"
            pleaseReviewSpecificCancellationLabel.text = "✓ يرجى مراجعة سياسة الإلغاء المحددة المدرجة في صفحة الفندق قبل تأكيد حجزك"
            forChangesCancellationsLabel.text = "✓ للتغييرات أو الإلغاءات، اتصل بالفندق مباشرة أو تواصل مع دعم عملاء SyriaBooking.sy"
            
            userResponsibilitiesTitleLabel.text = "مسؤوليات المستخدم:"
            byUsingthePlatformLabel.text = "✓ باستخدام المنصة، فإنك توافق على:"
            provideAccurateandHonestLabel.text = "✓ تقديم معلومات دقيقة وصادقة أثناء إجراء الحجز"
            abideByRulesAndPoliciesLabel.text = "✓ الالتزام بقواعد وسياسات العقار المحجوز"
            arriveOnTimeForCheckinLabel.text = "✓ الوصول في الوقت المحدد لتسجيل الوصول، أو إبلاغ الفندق في حالة التأخير"
            notUseThePlatformLabel.text = "✓ عدم استخدام المنصة لأغراض احتيالية أو غير قانونية أو غير أخلاقية"
            
            hotelResponsibilitiesTitleLabel.text = "مسؤوليات الفندق:"
            provideAccurateDescriptionLabel.text = "✓ تقديم أوصاف دقيقة وأسعار وتوافر"
            maintainSafetyCleanlinessLabel.text = "✓ الحفاظ على معايير السلامة والنظافة والجودة"
            honorConfirmedBookingsLabel.text = "✓ الوفاء بالحجوزات المؤكدة وفقاً للشروط المذكورة"
            informSyriaBookingSYLabel.text = "✓ إبلاغ SyriaBooking.sy والضيف بأي تغييرات لا مفر منها في الحجز"
            
            liabilityDisclaimerTitleLabel.text = "إخلاء المسؤولية:"
            syriaBookingisNotResponsibleForServiceLabel.text = "✓ SyriaBooking.sy ليست مسؤولة عن فشل الخدمة أو المشكلات الناجمة عن الفندق، بما في ذلك الحجز الزائد أو الإلغاءات أو الخدمة غير الملائمة"
            weAreNotLiableForPersonalInjuryLabel.text = "✓ نحن غير مسؤولين عن الإصابات الشخصية أو الخسائر أو الأضرار أو السرقة التي تحدث أثناء إقامتك"
            ourPlatformAndContentLabel.text = "✓ يتم توفير منصتنا ومحتواها على أساس \"كما هي\"، ونحن لا نضمن خدمة دون انقطاع أو قوائم خالية من الأخطاء"
            
            intellectualPropertTitleLabel.text = "الملكية الفكرية:"
            allContentBrandinglogosLabel.text = "✓ جميع المحتويات والعلامات التجارية والشعارات والبيانات على SyriaBooking.sy هي ملك لـ SyriaBooking أو المرخصين لها ولا يجوز نسخها أو إعادة استخدامها أو إعادة توزيعها دون إذن"
            
            privacyTitleLabel.text = "الخصوصية:"
            weAreCommittedtoProtectingLabel.text = "✓ نحن ملتزمون بحماية خصوصيتك. يرجى الرجوع إلى سياسة الخصوصية للحصول على التفاصيل الكاملة حول كيفية تعاملنا مع بياناتك الشخصية"
            
            terminationTitleLabel.text = "الإنهاء:"
            weReserveTheRightLabel.text = "✓ نحتفظ بالحق في تعليق أو إنهاء الوصول إلى منصتنا لأي مستخدم يتبين أنه انتهك هذه الشروط أو يستخدم الموقع بشكل غير لائق"
            
            governingLawTitleLabel.text = "القانون الحاكم:"
            theseTermsAndConditionsGovernedLabel.text = "✓ تخضع هذه الشروط والأحكام لقوانين الجمهورية العربية السورية. سيتم التعامل مع أي نزاعات من قبل محاكم دمشق، سوريا"
            
            contactInformationTitleLabel.text = "معلومات الاتصال:"
            forQuestionsAreConcernsLabel.text = "للاستفسارات أو المخاوف بشأن هذه الشروط، يرجى الاتصال بـ:"
            
            let contactSupportTitle = NSAttributedString(
                string: "اتصل بالدعم",
                attributes: [.font: bold15Font, .foregroundColor: UIColor.white]
            )
            contactSupportButton.setAttributedTitle(contactSupportTitle, for: .normal)
            
        } else {
            termsAndConditionsTitleLabel.text = "Terms & Conditions"
            redefineTravelLabel.text = "Redefining travel and hospitality within Syria"
            welcomeLabel.text = "Welcome to SyriaBooking.sy"
            theseTermsAndConditionsLabel.text = "These Terms & Conditions (\"Terms\") govern your use of the SyriaBooking.sy website and services. By accessing or using our platform, you agree to comply with these Terms in full. If you do not agree, please do not use our services."
            
            definitionsTitleLabel.text = "Definitions:"
            platformRefersToSyriaLabel.text = "✓ \"Platform\" refers to SyriaBooking.sy website and related services."
            userYouRefersToAnyOneLabel.text = "✓ \"User\", \"You\" refers to any person browsing, using, or booking through SyriaBooking.sy."
            hotelOrPropertyLabel.text = "✓ \"Hotel\" or \"Property\" means the accommodation provider listed on the platform."
            bookingMeansReservationMadeLabel.text = "✓ \"Booking\" means a reservation made through SyriaBooking.sy for accommodation."
            
            scopeOfOurServiceTitleLabel.text = "Scope of Our Service"
            syriaBookingProvidesLabel.text = "✓ SyriaBooking.sy provides an online platform for users to browse, compare, and reserve accommodations in Syria. We:"
            facilitiesHotelLabel.text = "✓ Facilitate hotel discovery and bookings"
            offerAPayOnArrivalLabel.text = "✓ Offer a \"Pay on Arrival\" model (no online payment required)"
            doNotOwnManageLabel.text = "✓ Do not own, manage, or operate any accommodation listed"
            allBookingsAreMadeDirectlyLabel.text = "✓ All bookings are made directly with the hotel; we act solely as an intermediary"
            
            bookingPolicyTitleLabel.text = "Booking Policy"
            youMayBookRoomsLabel.text = "✓ You may book rooms through the website without any prepayment"
            bookingConfirmationisSentLabel.text = "✓ Booking confirmation is sent via email or SMS after successful reservation"
            paymentIsMadeDirectlyLabel.text = "✓ Payment is made directly to the hotel at check-in, in cash or as per the hotel's accepted payment methods"
            someHotelsMayRequireLabel.text = "✓ Some hotels may require follow-up confirmation via phone/message; failure may result in cancellation"
            
            cancellationModificationTitleLabel.text = "Cancellation & Modification Policy:"
            mostBookingsCanbeModifiedLabel.text = "✓ Most bookings can be modified or canceled without charge, but cancellation terms vary by property"
            pleaseReviewSpecificCancellationLabel.text = "✓ Please review the specific cancellation policy listed on the hotel's page before confirming your booking"
            forChangesCancellationsLabel.text = "✓ For changes or cancellations, contact the hotel directly or reach out to SyriaBooking.sy customer support"
            
            userResponsibilitiesTitleLabel.text = "User Responsibilities:"
            byUsingthePlatformLabel.text = "✓ By using the platform, you agree to:"
            provideAccurateandHonestLabel.text = "✓ Provide accurate and honest information while making a booking"
            abideByRulesAndPoliciesLabel.text = "✓ Abide by the rules and policies of the booked property"
            arriveOnTimeForCheckinLabel.text = "✓ Arrive on time for check-in, or inform the hotel in case of delays"
            notUseThePlatformLabel.text = "✓ Not use the platform for fraudulent, illegal, or unethical purposes"
            
            hotelResponsibilitiesTitleLabel.text = "Hotel Responsibilities:"
            provideAccurateDescriptionLabel.text = "✓ Provide accurate descriptions, pricing, and availability"
            maintainSafetyCleanlinessLabel.text = "✓ Maintain safety, cleanliness, and quality standards"
            honorConfirmedBookingsLabel.text = "✓ Honor confirmed bookings under the stated terms"
            informSyriaBookingSYLabel.text = "✓ Inform SyriaBooking.sy and the guest of any unavoidable changes in booking"
            
            liabilityDisclaimerTitleLabel.text = "Liability Disclaimer:"
            syriaBookingisNotResponsibleForServiceLabel.text = "✓ SyriaBooking.sy is not responsible for service failures or issues caused by the hotel, including overbooking, cancellations, or inadequate service"
            weAreNotLiableForPersonalInjuryLabel.text = "✓ We are not liable for personal injury, loss, damage, or theft incurred during your stay"
            ourPlatformAndContentLabel.text = "✓ Our platform and content are provided on an \"as-is\" basis, and we do not guarantee uninterrupted service or error-free listings"
            
            intellectualPropertTitleLabel.text = "Intellectual Property:"
            allContentBrandinglogosLabel.text = "✓ All content, branding, logos, and data on SyriaBooking.sy are the property of SyriaBooking or its licensors and may not be copied, reused, or redistributed without permission"
            
            privacyTitleLabel.text = "Privacy:"
            weAreCommittedtoProtectingLabel.text = "✓ We are committed to protecting your privacy. Please refer to our Privacy Policy for full details on how we handle your personal data"
            
            terminationTitleLabel.text = "Termination:"
            weReserveTheRightLabel.text = "✓ We reserve the right to suspend or terminate access to our platform for any user found violating these terms or using the site inappropriately"
            
            governingLawTitleLabel.text = "Governing Law:"
            theseTermsAndConditionsGovernedLabel.text = "✓ These Terms & Conditions are governed by the laws of the Syrian Arab Republic. Any disputes will be handled by the courts of Damascus, Syria"
            
            contactInformationTitleLabel.text = "Contact Information:"
            forQuestionsAreConcernsLabel.text = "For questions or concerns about these Terms, please contact:"
            
            let contactSupportTitle = NSAttributedString(
                string: "Contact Support",
                attributes: [.font: bold15Font, .foregroundColor: UIColor.white]
            )
            contactSupportButton.setAttributedTitle(contactSupportTitle, for: .normal)
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
        let lang = AppSettings.shared.selectedLanguage
        let alertTitle = lang == .arabic ? "رقم الهاتف" : "Phone Number"
        let alertMessage = lang == .arabic ?
            "هذا الجهاز لا يمكنه إجراء المكالمات. يمكنك نسخ الرقم \(phoneNumber) للاتصال يدوياً." :
            "This device cannot make phone calls. You can copy the number \(phoneNumber) to call manually."
        let copyTitle = lang == .arabic ? "نسخ الرقم" : "Copy Number"
        let cancelTitle = lang == .arabic ? "إلغاء" : "Cancel"
        
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
        let lang = AppSettings.shared.selectedLanguage
        let message = lang == .arabic ? "تم نسخ الرقم بنجاح" : "Number copied successfully"
        
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
        let lang = AppSettings.shared.selectedLanguage
        let alertTitle = lang == .arabic ? "اتصال طارئ" : "Emergency Call"
        let alertMessage = lang == .arabic ?
            "هل تريد الاتصال برقم الطوارئ \(phoneNumber)؟" :
            "Do you want to call emergency number \(phoneNumber)?"
        let cancelTitle = lang == .arabic ? "إلغاء" : "Cancel"
        let callTitle = lang == .arabic ? "اتصال طارئ" : "Emergency Call"
        
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
    
    @IBAction func emailIDButtonAction(_ sender: Any) {
        let lang = AppSettings.shared.selectedLanguage
        let subject = lang == .arabic ?
            "استفسار حول الشروط والأحكام" : "Terms and Conditions Inquiry"
        sendEmail(to: "info@syriabooking.sy", subject: subject)
    }
    
    @IBAction func contactSupportButtonAction(_ sender: Any) {
        makePhoneCall(to: "+963123456789", isEmergency: false)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
