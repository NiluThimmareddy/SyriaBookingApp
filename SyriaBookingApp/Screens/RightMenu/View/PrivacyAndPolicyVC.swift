//
//  PrivacyAndPolicyVC.swift
//  SyriaBookingApp
//
//  Created by Hitman on 30/03/26.

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
        updateTexts()
    }
    
    @objc func updateTexts() {
        let lang = AppSettings.shared.selectedLanguage
        let semibold16Font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        
        if lang == .arabic {
            lastUpdateLabel.text = "آخر تحديث: ١٧ مارس ٢٠٢٥"
            whatInformationWeCollectLabel.text = "ما هي المعلومات التي نجمعها"
            whenYouUseSyriaBookingLabel.text = "عند استخدامك لـ SyriaBooking.sy، قد نجمع الأنواع التالية من المعلومات:"
            aPersonalDataLabel.text = "أ. البيانات الشخصية"
            fullnameLabel.text = "✓ الاسم الكامل"
            emailAddressLabel.text = "✓ عنوان البريد الإلكتروني"
            phoneNumberLabel.text = "✓ رقم الهاتف"
            bookingReferenceLabel.text = "✓ تفضيلات الحجز (اسم الفندق، المدينة، تواريخ السفر)"
            specialRequestLabel.text = "✓ الطلبات الخاصة، إن وجدت"
            weDoNotCollectCreditCardLabel.text = "نحن لا نجمع معلومات بطاقة الائتمان أو معلومات الدفع، حيث يتم الدفع مباشرة في الفندق."
            technicalDataLabel.text = "ب. البيانات التقنية"
            iPAddressLabel.text = "✓ عنوان IP"
            browserTypeVersionLabel.text = "✓ نوع المتصفح والإصدار"
            deviceTypeLabel.text = "✓ نوع الجهاز"
            locationPermittedBrowserLabel.text = "✓ الموقع (إذا سمحت إعدادات المتصفح/الجهاز)"
            pagesVisitedInteractionLabel.text = "✓ الصفحات التي تمت زيارتها وسلوك التفاعل"
            
            howWeUseYourInformationLabel.text = "كيف نستخدم معلوماتك"
            weUseYourDataToLabel.text = "نحن نستخدم بياناتك لـ:"
            processAndConfirmYourBookingsLabel.text = "✓ معالجة وتأكيد حجوزات الفندق الخاصة بك"
            sendBookingConfirmationsLabel.text = "✓ إرسال تأكيدات الحجز والتحديثات عبر البريد الإلكتروني/الرسائل القصيرة"
            improveUserExperienceLabel.text = "✓ تحسين تجربة المستخدم وتحسين أداء موقعنا"
            respondToCustomerServiceLabel.text = "✓ الرد على طلبات خدمة العملاء أو مشكلات الدعم"
            preventFraudOrMisuseLabel.text = "✓ منع الاحتيال أو إساءة استخدام منصتنا"
            sendServiceUpdateOrOffersLabel.text = "✓ إرسال تحديثات الخدمة أو العروض (فقط بموافقتك)"
            
            howWeShareYourInformationLabel.text = "كيف نشارك معلوماتك"
            weOnlyShareYourInformationLabel.text = "نحن نشارك معلوماتك فقط مع:"
            theHotelYouHaveBookedWithLabel.text = "✓ الفندق الذي حجزت معه (لأغراض الحجز فقط)"
            ourInternalCustomerLabel.text = "✓ فرق دعم العملاء والتقنية الداخلية لدينا"
            legalAuthoritiesRequiredLabel.text = "✓ السلطات القانونية عندما يقتضي القانون أو اللوائح ذلك"
            
            dataSecurityLabel.text = "أمن البيانات"
            weImplementAppropriateTechnicalLabel.text = "نحن ننفذ تدابير أمنية تقنية وتنظيمية مناسبة لحماية بياناتك الشخصية من الوصول غير المصرح به أو التغيير أو سوء الاستخدام."
            encryptedConnectionLabel.text = "✓ اتصال مشفر (HTTPS)"
            secureDatabaseStorageLabel.text = "✓ تخزين آمن في قاعدة البيانات"
            limitedAccessToAuthorizedLabel.text = "✓ وصول محدود للموظفين المصرح لهم فقط"
            
            dataRetentionLabel.text = "الاحتفاظ بالبيانات"
            weRetainYourPersonalDataLabel.text = "نحن نحتفظ ببياناتك الشخصية فقط طالما كانت ضرورية لتنفيذ حجوزاتك أو الامتثال للالتزامات القانونية."
            youMayRequestDeletionYourDataLabel.text = "يمكنك طلب حذف بياناتك في أي وقت عن طريق الاتصال بنا على careers@syriabooking.sy"
            
            cookiePolicyLabel.text = "سياسة ملفات تعريف الارتباط"
            whatAreCookiesLabel.text = "أ. ما هي ملفات تعريف الارتباط؟"
            cookiesAreSmallTextFilesLabel.text = "✓ ملفات تعريف الارتباط هي ملفات نصية صغيرة يتم تخزينها على جهازك عند زيارة موقع ويب. تساعدنا في فهم تفضيلاتك وتحسين تجربتك."
            typeOfCookiesWeUseLabel.text = "ب. أنواع ملفات تعريف الارتباط التي نستخدمها"
            essentialCookiesLabel.text = "✓ ملفات تعريف الارتباط الأساسية: تمكن الوظائف الأساسية مثل الحجز وتسجيل الدخول."
            performanceCookiesLabel.text = "✓ ملفات تعريف ارتباط الأداء: تساعدنا في فهم سلوك المستخدم وتحسين الأداء"
            functionalityCookiesLabel.text = "✓ ملفات تعريف ارتباط الوظائف: تتذكر إعداداتك وتفضيلاتك"
            analyticsCookiesLabel.text = "✓ ملفات تعريف ارتباط التحليلات: تتبع الاستخدام لمساعدتنا في تحسين المحتوى والتخطيط"
            managingCookiesLabel.text = "ج. إدارة ملفات تعريف الارتباط"
            youCanmanageOrDisableCookiesLabel.text = "✓ يمكنك إدارة أو تعطيل ملفات تعريف الارتباط عبر إعدادات المتصفح الخاص بك. ومع ذلك، قد لا تعمل بعض أجزاء موقعنا بشكل صحيح بدون ملفات تعريف الارتباط."
            
            internationalUsersLabel.text = "المستخدمون الدوليون"
            syriaBookingIsBasedinSyriaPlatformLabel.text = "SyriaBooking.sy مقرها في سوريا. باستخدام منصتنا، فإنك توافق على معالجة وتخزين بياناتك الشخصية داخل سوريا أو في بلدان أخرى حيث تعمل أنظمتنا."
            
            yourRightsLabel.text = "حقوقك"
            youHavetheRightToLabel.text = "لديك الحق في:"
            accessYourPersonalDataLabel.text = "✓ الوصول إلى بياناتك الشخصية"
            requestCorrectionOfInaccurateDataLabel.text = "✓ طلب تصحيح البيانات غير الدقيقة"
            requestDeletionOfYourDataLabel.text = "✓ طلب حذف بياناتك (حيثما ينطبق ذلك)"
            withDrawYourConsentMarketingLabel.text = "✓ سحب موافقتك على التواصل التسويقي"
            lodgeComplaintWithADataLabel.text = "✓ تقديم شكوى إلى سلطة حماية البيانات (إذا كان ذلك ممكناً)"
            
            contactUsLabel.text = "اتصل بنا"
            forQuestionsRequestsLabel.text = "للاستفسارات أو الطلبات أو المخاوف المتعلقة بالخصوصية أو ملفات تعريف الارتباط، يرجى الاتصال بـ:"
            emailTitleLabel.text = "البريد الإلكتروني:"
            needHelpWithPrivacyQuestionsLabel.text = "هل تحتاج مساعدة في أسئلة الخصوصية؟"
            
            let contactSupportTitle = NSAttributedString(
                string: "اتصل بالدعم",
                attributes: [.font: semibold16Font, .foregroundColor: UIColor.white]
            )
            contactSupportButton.setAttributedTitle(contactSupportTitle, for: .normal)
            
            thankyouForVisitingLabel.text = "شكراً لزيارتك!"
            byUsingourWebsiteServicsLabel.text = "باستخدام موقعنا الإلكتروني أو خدماتنا، فإنك توافق على شروط سياسة الخصوصية هذه. يرجى مراجعة هذه السياسة بشكل دوري للتحديثات أو التغييرات."
            
        } else {
            lastUpdateLabel.text = "Last update: Mar 17, 2025"
            
            whatInformationWeCollectLabel.text = "What Information We Collect"
            whenYouUseSyriaBookingLabel.text = "When you use SyriaBooking.sy, we may collect the following types of information:"
            aPersonalDataLabel.text = "a. Personal Data"
            fullnameLabel.text = "✓ Full name"
            emailAddressLabel.text = "✓ Email address"
            phoneNumberLabel.text = "✓ Phone number"
            bookingReferenceLabel.text = "✓ Booking preferences (hotel name, city, travel dates)"
            specialRequestLabel.text = "✓ Special requests, if any"
            weDoNotCollectCreditCardLabel.text = "We do not collect credit card or payment information, as all payments are made directly at the hotel."
            technicalDataLabel.text = "b. Technical Data"
            iPAddressLabel.text = "✓ IP address"
            browserTypeVersionLabel.text = "✓ Browser type and version"
            deviceTypeLabel.text = "✓ Device type"
            locationPermittedBrowserLabel.text = "✓ Location (if permitted by browser/device settings)"
            pagesVisitedInteractionLabel.text = "✓ Pages visited and interaction behavior"
            
            howWeUseYourInformationLabel.text = "How We Use Your Information"
            weUseYourDataToLabel.text = "We use your data to:"
            processAndConfirmYourBookingsLabel.text = "✓ Process and confirm your hotel bookings"
            sendBookingConfirmationsLabel.text = "✓ Send booking confirmations and updates via email/SMS"
            improveUserExperienceLabel.text = "✓ Improve user experience and optimize our website performance"
            respondToCustomerServiceLabel.text = "✓ Respond to customer service requests or support issues"
            preventFraudOrMisuseLabel.text = "✓ Prevent fraud or misuse of our platform"
            sendServiceUpdateOrOffersLabel.text = "✓ Send service updates or offers (only with your consent)"
            
            howWeShareYourInformationLabel.text = "How We Share Your Information"
            weOnlyShareYourInformationLabel.text = "We only share your information with:"
            theHotelYouHaveBookedWithLabel.text = "✓ The hotel you have booked with (for reservation purposes only)"
            ourInternalCustomerLabel.text = "✓ Our internal customer support and tech teams"
            legalAuthoritiesRequiredLabel.text = "✓ Legal authorities when required by law or regulation"
            
            dataSecurityLabel.text = "Data Security"
            weImplementAppropriateTechnicalLabel.text = "We implement appropriate technical and organizational security measures to protect your personal data from unauthorized access, alteration, or misuse."
            encryptedConnectionLabel.text = "✓ Encrypted connection (HTTPS)"
            secureDatabaseStorageLabel.text = "✓ Secure database storage"
            limitedAccessToAuthorizedLabel.text = "✓ Limited access to authorized personnel only"
            
            dataRetentionLabel.text = "Data Retention"
            weRetainYourPersonalDataLabel.text = "We retain your personal data only as long as needed to fulfill your bookings or comply with legal obligations."
            youMayRequestDeletionYourDataLabel.text = "You may request deletion of your data at any time by contacting us at careers@syriabooking.sy"
            
            cookiePolicyLabel.text = "Cookie Policy"
            whatAreCookiesLabel.text = "a. What Are Cookies?"
            cookiesAreSmallTextFilesLabel.text = "✓ Cookies are small text files stored on your device when you visit a website. They help us understand your preferences and improve your experience."
            typeOfCookiesWeUseLabel.text = "b. Types of Cookies We Use"
            essentialCookiesLabel.text = "✓ Essential Cookies: Enable core functionality like booking and login."
            performanceCookiesLabel.text = "✓ Performance Cookies: Help us understand user behavior and improve performance"
            functionalityCookiesLabel.text = "✓ Functionality Cookies: Remember your settings and preferences"
            analyticsCookiesLabel.text = "✓ Analytics Cookies: Track usage to help us improve content and layout"
            managingCookiesLabel.text = "c. Managing Cookies"
            youCanmanageOrDisableCookiesLabel.text = "✓ You can manage or disable cookies via your browser settings. However, some parts of our website may not work properly without cookies."
            
            internationalUsersLabel.text = "International Users"
            syriaBookingIsBasedinSyriaPlatformLabel.text = "SyriaBooking.sy is based in Syria. By using our platform, you agree that your personal data will be processed and stored within Syria or in other countries where our systems operate."
            
            yourRightsLabel.text = "Your Rights"
            youHavetheRightToLabel.text = "You have the right to:"
            accessYourPersonalDataLabel.text = "✓ Access your personal data"
            requestCorrectionOfInaccurateDataLabel.text = "✓ Request correction of inaccurate data"
            requestDeletionOfYourDataLabel.text = "✓ Request deletion of your data (where applicable)"
            withDrawYourConsentMarketingLabel.text = "✓ Withdraw your consent for marketing communication"
            lodgeComplaintWithADataLabel.text = "✓ Lodge a complaint with a data protection authority (if applicable)"
            
            contactUsLabel.text = "Contact Us"
            forQuestionsRequestsLabel.text = "For questions, requests, or concerns related to privacy or cookies, please contact:"
            emailTitleLabel.text = "Email:"
            needHelpWithPrivacyQuestionsLabel.text = "Need help with privacy questions?"
            
            let contactSupportTitle = NSAttributedString(
                string: "Contact Support",
                attributes: [.font: semibold16Font, .foregroundColor: UIColor.white]
            )
            contactSupportButton.setAttributedTitle(contactSupportTitle, for: .normal)
            
            thankyouForVisitingLabel.text = "Thank you for visiting!"
            byUsingourWebsiteServicsLabel.text = "By using our website or services, you consent to the terms of this Privacy Policy. Please review this policy periodically for updates or changes."
        }
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
    
    @IBAction func emailButtonAction(_ sender: Any) {
        let lang = AppSettings.shared.selectedLanguage
        let subject = lang == .arabic ?
            "استفسار حول سياسة الخصوصية" : "Privacy Policy Inquiry"
        sendEmail(to: "careers@syriabooking.sy", subject: subject)
    }
    
    @IBAction func contactSupportButtonAction(_ sender: Any) {
        makePhoneCall(to: "+963123456789", isEmergency: false)
    }
}
