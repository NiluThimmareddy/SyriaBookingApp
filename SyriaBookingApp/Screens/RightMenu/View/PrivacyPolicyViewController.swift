
import UIKit
import WebKit

class PrivacyPolicyViewController: UIViewController, WKNavigationDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var privacyPolicyLabel: UILabel!
    @IBOutlet weak var redefiningTravelDescriptionLabel: UILabel!
    @IBOutlet weak var followLinksView: UIView!
    
    private var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupWebView()
        setupSocialMediaView()
    }
    
    private func setupWebView() {
        let configuration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: configuration)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.navigationDelegate = self
        webView.scrollView.isScrollEnabled = false
        
        bottomView.addSubview(webView)
        
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor),
            webView.topAnchor.constraint(equalTo: bottomView.topAnchor),
            webView.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor)
        ])
        
        loadHTMLContent()
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
    
    private func loadHTMLContent() {
        let htmlString: String
        
        if AppSettings.shared.selectedLanguage == .arabic {
            privacyPolicyLabel.text = "بيان الخصوصية وملفات تعريف الارتباط"
            redefiningTravelDescriptionLabel.text = "إعادة تعريف السفر والضيافة داخل سوريا."
            htmlString = """
            <html lang="ar" dir="rtl">
            <head>
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <style>
                    body {
                        font-family: -apple-system, BlinkMacSystemFont, "Helvetica Neue", Arial, sans-serif;
                        padding: 20px;
                        color: #333333;
                        font-size: 13px;
                        line-height: 1.3;
                        direction: rtl;
                        text-align: right;
                    }
                    h2 { font-size: 18px; font-weight: 700; margin-top: 24px; margin-bottom: 8px; color: #000000; }
                    h5 { font-size: 14px; font-weight: 600; margin-top: 16px; margin-bottom: 6px; color: #000000; }
                    h6 { font-size: 13px; font-weight: 500; margin-top: 12px; margin-bottom: 6px; color: #222222; }
                    p { margin-bottom: 8px; font-size: 13px; font-weight: 400; color: #333333; }
                    ul { padding-right: 16px; margin-top: 2px; margin-bottom: 12px; }
                    li { margin-bottom: 4px; font-size: 13px; }
                    a { color: #007AFF; text-decoration: none; font-size: 13px; font-weight: 500; }
                    strong { font-weight: 600; font-size: 14px; }
                    em { font-style: italic; color: #666666; }
                </style>
            </head>
            <body>
                <p>في SyriaBooking.sy، نحترم خصوصيتك ونلتزم بحماية بياناتك الشخصية. توضح سياسة الخصوصية وملفات تعريف الارتباط هذه كيف نجمع ونستخدم ونخزن ونحمي معلوماتك الشخصية، وكيف نستخدم ملفات تعريف الارتباط عند زيارة أو استخدام موقعنا.</p>
            
                <h5>1. ما هي المعلومات التي نجمعها:</h5>
                <p>عند استخدامك SyriaBooking.sy، قد نقوم بجمع الأنواع التالية من المعلومات:</p>
                <ul>
                    <li><strong>أ. البيانات الشخصية</strong><br>
                        الاسم الكامل<br>
                        البريد الإلكتروني<br>
                        رقم الهاتف<br>
                        تفضيلات الحجز (اسم الفندق، المدينة، تواريخ السفر)<br>
                        الطلبات الخاصة إن وجدت
                    </li>
                    <li><strong>ب. البيانات التقنية</strong><br>
                        عنوان IP<br>
                        نوع وإصدار المتصفح<br>
                        نوع الجهاز<br>
                        الموقع (إذا سمحت إعدادات المتصفح/الجهاز)<br>
                        الصفحات التي تمت زيارتها وسلوك التفاعل
                    </li>
                </ul>
                <p><em>نحن لا نجمع معلومات بطاقات الدفع أو الائتمان، فجميع المدفوعات تتم مباشرة في الفندق.</em></p>
            
                <h5>2. كيف نستخدم معلوماتك:</h5>
                <ul>
                    <li>معالجة وتأكيد حجوزاتك الفندقية</li>
                    <li>إرسال تأكيدات الحجز والتحديثات عبر البريد الإلكتروني/SMS</li>
                    <li>تحسين تجربة المستخدم وتحسين أداء الموقع</li>
                    <li>الرد على طلبات خدمة العملاء أو المشاكل الفنية</li>
                    <li>منع الاحتيال أو إساءة استخدام منصتنا</li>
                    <li>إرسال تحديثات أو عروض (بموافقتك فقط)</li>
                </ul>
            
                <h5>3. كيف نشارك معلوماتك:</h5>
                <ul>
                    <li>الفندق الذي قمت بالحجز فيه (لأغراض الحجز فقط)</li>
                    <li>فرق الدعم الفني وخدمة العملاء الداخلية</li>
                    <li>السلطات القانونية عند الحاجة وفق القانون</li>
                </ul>
            
                <h5>4. أمان البيانات:</h5>
                <p>نطبق التدابير الأمنية المناسبة لحماية بياناتك من الوصول غير المصرح به أو التغيير أو إساءة الاستخدام.</p>
                <ul>
                    <li>اتصال مشفر (HTTPS)</li>
                    <li>تخزين آمن للبيانات</li>
                    <li>وصول محدود للموظفين المصرح لهم فقط</li>
                </ul>
            
                <h5>5. مدة الاحتفاظ بالبيانات:</h5>
                <p>نحتفظ ببياناتك فقط للمدة اللازمة لتنفيذ الحجوزات أو الامتثال للقوانين. يمكنك طلب حذف بياناتك في أي وقت عبر البريد الإلكتروني <a href="mailto:info@syriabooking.sy">info@syriabooking.sy</a>.</p>
            
                <h5>6. سياسة ملفات تعريف الارتباط:</h5>
                <p><strong>أ. ما هي ملفات تعريف الارتباط؟</strong><br>
                هي ملفات نصية صغيرة تُخزن على جهازك عند زيارة الموقع. تساعدنا على فهم تفضيلاتك وتحسين تجربتك.</p>
            
                <p><strong>ب. أنواع ملفات تعريف الارتباط التي نستخدمها</strong></p>
                <ul>
                    <li><strong>ضرورية:</strong> تمكّن الوظائف الأساسية مثل الحجز وتسجيل الدخول</li>
                    <li><strong>الأداء:</strong> تساعدنا على فهم سلوك المستخدم وتحسين الأداء</li>
                    <li><strong>الوظيفية:</strong> تتذكر إعداداتك وتفضيلاتك</li>
                    <li><strong>التحليلية:</strong> تتبع الاستخدام لتحسين المحتوى والتصميم</li>
                </ul>
            
                <p><strong>ج. إدارة ملفات تعريف الارتباط</strong><br>
                يمكنك إدارتها أو تعطيلها من إعدادات المتصفح. لكن بعض أجزاء الموقع قد لا تعمل بشكل صحيح بدونها.</p>
            
                <h5>7. المستخدمون الدوليون:</h5>
                <p>SyriaBooking.sy مقرها في سوريا. باستخدامك منصتنا، فإنك توافق على معالجة بياناتك وتخزينها داخل سوريا أو في دول أخرى حيث تعمل أنظمتنا.</p>
            
                <h5>8. حقوقك:</h5>
                <ul>
                    <li>الوصول إلى بياناتك الشخصية</li>
                    <li>طلب تصحيح البيانات غير الدقيقة</li>
                    <li>طلب حذف بياناتك (حيثما ينطبق)</li>
                    <li>سحب موافقتك على الاتصالات التسويقية</li>
                    <li>تقديم شكوى إلى جهة حماية البيانات (إذا كانت موجودة)</li>
                </ul>
            
                <h5>9. تواصل معنا:</h5>
                <p>للاستفسارات أو الطلبات المتعلقة بالخصوصية أو ملفات تعريف الارتباط، يرجى التواصل معنا:</p>
                <p><strong>البريد:</strong> <a href="mailto:info@syriabooking.sy">info@syriabooking.sy</a><br>
                <strong>الهاتف:</strong> <a href="tel:+963123456789">+963-123-456789</a></p>
            
                <h6>شكراً لزيارتكم!</h6>
                <p>باستخدامك موقعنا أو خدماتنا، فإنك توافق على شروط سياسة الخصوصية هذه. يرجى مراجعتها دورياً للتحديثات أو التغييرات.</p>
            <p style="margin-top: 20px; font-weight: 500;">
                مع أطيب التحيات،<br>
                فريق SyriaBooking
            </p>
            </body>
            </html>
            """
        } else {
            privacyPolicyLabel.text = "Privacy & Cookie Statement"
            redefiningTravelDescriptionLabel.text = "Redefining travel and hospitality within Syria."
            htmlString = """
            <html lang="en" dir="ltr">
            <head>
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <style>
                    body {
                        font-family: -apple-system, BlinkMacSystemFont, "Helvetica Neue", Arial, sans-serif;
                        padding: 20px;
                        color: #333333;
                        font-size: 13px;
                        line-height: 1.3;
                        direction: ltr;
                        text-align: left;
                    }
                    h2 { font-size: 18px; font-weight: 700; margin-top: 24px; margin-bottom: 8px; color: #000000; }
                    h5 { font-size: 14px; font-weight: 600; margin-top: 16px; margin-bottom: 6px; color: #000000; }
                    h6 { font-size: 13px; font-weight: 500; margin-top: 12px; margin-bottom: 6px; color: #222222; }
                    p { margin-bottom: 8px; font-size: 13px; font-weight: 400; color: #333333; }
                    ul { padding-left: 16px; margin-top: 2px; margin-bottom: 12px; }
                    li { margin-bottom: 4px; font-size: 13px; }
                    a { color: #007AFF; text-decoration: none; font-size: 13px; font-weight: 500; }
                    strong { font-weight: 600; font-size: 14px; }
                    em { font-style: italic; color: #666666; }
                </style>
            </head>
            <body>
                <p>At SyriaBooking.sy, we respect your privacy and are committed to protecting your personal data. This Privacy & Cookie Statement explains how we collect, use, store, and protect your personal information, and how we use cookies when you visit or use our website.</p>
            
                <h5>1. What Information We Collect:</h5>
                <p>When you use SyriaBooking.sy, we may collect the following types of information:</p>
                <ul>
                    <li><strong>a. Personal Data</strong><br>
                        Full name<br>
                        Email address<br>
                        Phone number<br>
                        Booking preferences (hotel name, city, travel dates)<br>
                        Special requests, if any
                    </li>
                    <li><strong>b. Technical Data</strong><br>
                        IP address<br>
                        Browser type and version<br>
                        Device type<br>
                        Location (if permitted by browser/device settings)<br>
                        Pages visited and interaction behavior
                    </li>
                </ul>
                <p><em>We do not collect credit card or payment information, as all payments are made directly at the hotel.</em></p>
            
                <h5>2. How We Use Your Information:</h5>
                <ul>
                    <li>Process and confirm your hotel bookings</li>
                    <li>Send booking confirmations and updates via email/SMS</li>
                    <li>Improve user experience and optimize our website performance</li>
                    <li>Respond to customer service requests or support issues</li>
                    <li>Prevent fraud or misuse of our platform</li>
                    <li>Send service updates or offers (only with your consent)</li>
                </ul>
            
                <h5>3. How We Share Your Information:</h5>
                <ul>
                    <li>The hotel you have booked with (for reservation purposes only)</li>
                    <li>Our internal customer support and tech teams</li>
                    <li>Legal authorities when required by law or regulation</li>
                </ul>
            
                <h5>4. Data Security:</h5>
                <p>We implement appropriate technical and organizational security measures to protect your personal data from unauthorized access, alteration, or misuse.</p>
                <ul>
                    <li>Encrypted connection (HTTPS)</li>
                    <li>Secure database storage</li>
                    <li>Limited access to authorized personnel only</li>
                </ul>
            
                <h5>5. Data Retention:</h5>
                <p>We retain your personal data only as long as needed to fulfill your bookings or comply with legal obligations. You may request deletion of your data at any time by contacting us at <a href="mailto:info@syriabooking.sy">info@syriabooking.sy</a>.</p>
            
                <h5>6. Cookie Policy:</h5>
                <p><strong>a. What Are Cookies?</strong><br>
                Cookies are small text files stored on your device when you visit a website. They help us understand your preferences and improve your experience.</p>
            
                <p><strong>b. Types of Cookies We Use</strong></p>
                <ul>
                    <li><strong>Essential Cookies:</strong> Enable core functionality like booking and login</li>
                    <li><strong>Performance Cookies:</strong> Help us understand user behavior and improve performance</li>
                    <li><strong>Functionality Cookies:</strong> Remember your settings and preferences</li>
                    <li><strong>Analytics Cookies:</strong> Track usage to help us improve content and layout</li>
                </ul>
            
                <p><strong>c. Managing Cookies</strong><br>
                You can manage or disable cookies via your browser settings. However, some parts of our website may not work properly without cookies.</p>
            
                <h5>7. International Users:</h5>
                <p>SyriaBooking.sy is based in Syria. By using our platform, you agree that your personal data will be processed and stored within Syria or in other countries where our systems operate.</p>
            
                <h5>8. Your Rights:</h5>
                <ul>
                    <li>Access your personal data</li>
                    <li>Request correction of inaccurate data</li>
                    <li>Request deletion of your data (where applicable)</li>
                    <li>Withdraw your consent for marketing communication</li>
                    <li>Lodge a complaint with a data protection authority (if applicable)</li>
                </ul>
            
                <h5>9. Contact Us:</h5>
                <p>For questions, requests, or concerns related to privacy or cookies, please contact:</p>
                <p><strong>Email:</strong> <a href="mailto:info@syriabooking.sy">info@syriabooking.sy</a><br>
                <strong>Phone:</strong> <a href="tel:+963123456789">+963-123-456789</a></p>
            
                <h6>Thank you for visiting!</h6>
                <p>By using our website or services, you consent to the terms of this Privacy Policy. Please review this policy periodically for updates or changes.</p>
            <p style="margin-top: 20px; font-weight: 500;">
                Best regards,<br>
                SyriaBooking Team
            </p>
            </body>
            </html>
            """
        }
        
        webView.loadHTMLString(htmlString, baseURL: nil)
    }
    
    // MARK: - WKNavigationDelegate
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let url = navigationAction.request.url else {
            decisionHandler(.allow)
            return
        }
        if url.scheme == "mailto" {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: { success in
                    if !success {
                        print("Failed to open email client")
                    }
                })
            } else {
                print("Mail app is not available")
                let alert = UIAlertController(
                    title: AppSettings.shared.selectedLanguage == .arabic ?
                           "لا يمكن إرسال بريد إلكتروني" : "Cannot Send Email",
                    message: AppSettings.shared.selectedLanguage == .arabic ?
                            "تطبيق البريد الإلكتروني غير مثبت على هذا الجهاز." :
                            "Mail app is not configured on this device.",
                    preferredStyle: .alert
                )
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                present(alert, animated: true)
            }
            decisionHandler(.cancel)
            return
        }
        
        if url.scheme == "tel" {
            if UIApplication.shared.canOpenURL(url) {
                let phoneNumber = url.absoluteString.replacingOccurrences(of: "tel:", with: "")
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
                alert.addAction(UIAlertAction(title: callTitle, style: .default, handler: { _ in
                    UIApplication.shared.open(url, options: [:], completionHandler: { success in
                        if !success {
                            print("Failed to initiate phone call")
                        }
                    })
                }))
                
                present(alert, animated: true)
            }
            decisionHandler(.cancel)
            return
        }
        
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.evaluateJavaScript("document.body.scrollHeight") { (result, error) in
            if let height = result as? CGFloat {
                DispatchQueue.main.async {
                    self.updateWebViewHeight(height)
                }
            }
        }
    }
    
    private func updateWebViewHeight(_ height: CGFloat) {
        bottomView.constraints.forEach { constraint in
            if constraint.firstAttribute == .height {
                bottomView.removeConstraint(constraint)
            }
        }
        
        let newHeight = height
        let heightConstraint = bottomView.heightAnchor.constraint(equalToConstant: newHeight)
        heightConstraint.priority = UILayoutPriority(750)
        heightConstraint.isActive = true
        self.view.layoutIfNeeded()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let contentHeight = contentView.systemLayoutSizeFitting(
            CGSize(width: contentView.frame.width, height: UIView.layoutFittingCompressedSize.height)
        ).height
        scrollView.contentSize = CGSize(width: scrollView.frame.width, height: contentHeight)
    }
}
