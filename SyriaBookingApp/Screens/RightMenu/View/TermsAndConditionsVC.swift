//
//  TermsAndConditionsVC.swift
//  SyriaBookingApp
//
//  Created by toqsoft on 19/08/25.
//

import UIKit
import WebKit

class TermsAndConditionsVC: UIViewController, WKNavigationDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var termsAndConditionsLabel: UILabel!
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
            termsAndConditionsLabel.text = "الشروط والأحكام"
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
                    h2 { font-size: 18px; font-weight: 700; margin-top: 20px; margin-bottom: 6px; color: #000000; }
                    h5 { font-size: 14px; font-weight: 600; margin-top: 14px; margin-bottom: 4px; color: #000000; }
                    h6 { font-size: 13px; font-weight: 500; margin-top: 12px; margin-bottom: 4px; color: #222222; }
                    p { margin-bottom: 8px; font-size: 13px; font-weight: 400; color: #333333; }
                    ul { padding-right: 16px; margin-top: 2px; margin-bottom: 10px; }
                    li { margin-bottom: 4px; font-size: 13px; }
                    a { color: #007AFF; text-decoration: none; font-size: 13px; font-weight: 500; }
                    strong { font-weight: 600; font-size: 14px; }
                    em { font-style: italic; color: #666666; }
                </style>
            </head>
            <body>
                <p>مرحباً بكم في SyriaBooking.sy</p>
                <p>تحكم هذه الشروط والأحكام ("الشروط") استخدامك لموقع SyriaBooking.sy والخدمات المقدمة من خلاله...</p>
            
                <h5>1. التعريفات:</h5>
                <ul>
                    <li><strong>"المنصة"</strong> تشير إلى موقع SyriaBooking.sy والخدمات المرتبطة به.</li>
                    <li><strong>"المستخدم" أو "أنت"</strong> يشير إلى أي شخص يقوم بتصفح أو استخدام أو الحجز عبر SyriaBooking.sy.</li>
                    <li><strong>"الفندق" أو "مكان الإقامة"</strong> يعني مزود الإقامة المدرج على المنصة.</li>
                    <li><strong>"الحجز"</strong> يعني حجز إقامة تم عبر SyriaBooking.sy.</li>
                </ul>
            
                <h5>2. نطاق خدماتنا:</h5>
                <p>يوفر SyriaBooking.sy منصة إلكترونية للمستخدمين لتصفح ومقارنة وحجز أماكن الإقامة في سوريا...</p>
            
                <h5>3. سياسة الحجز:</h5>
                <ul>
                    <li>يمكنك حجز الغرف من خلال الموقع دون أي دفعات مسبقة.</li>
                    <li>يتم إرسال تأكيد الحجز عبر البريد الإلكتروني أو الرسائل القصيرة بعد إتمام الحجز بنجاح.</li>
                    <li>يتم الدفع مباشرة في الفندق عند تسجيل الوصول، نقداً أو وفق طرق الدفع التي يقبلها الفندق.</li>
                    <li>قد يطلب بعض الفنادق تأكيداً إضافياً عبر الهاتف أو الرسائل؛ عدم التأكيد قد يؤدي إلى إلغاء الحجز.</li>
                </ul>
            
                <h5>4. سياسة الإلغاء والتعديل:</h5>
                <ul>
                    <li>يمكن تعديل أو إلغاء معظم الحجوزات دون رسوم، ولكن شروط الإلغاء تختلف من فندق إلى آخر.</li>
                    <li>يرجى مراجعة سياسة الإلغاء المحددة المدرجة في صفحة الفندق قبل تأكيد حجزك.</li>
                    <li>للتغييرات أو عمليات الإلغاء، اتصل بالفندق مباشرة أو تواصل مع دعم عملاء SyriaBooking.sy.</li>
                </ul>
            
                <h5>5. مسؤوليات المستخدم:</h5>
                <p>باستخدامك المنصة، فإنك توافق على:</p>
                <ul>
                    <li>تقديم معلومات دقيقة وصادقة أثناء إجراء الحجز</li>
                    <li>الالتزام بالقواعد والسياسات الخاص بالملكية المحجوزة</li>
                    <li>الوصول في الوقت المحدد لتسجيل الوصول، أو إعلام الفندق في حالة التأخير</li>
                    <li>عدم استخدام المنصة لأغراض احتيالية أو غير قانونية أو غير أخلاقية</li>
                </ul>
            
                <h5>6. مسؤوليات الفندق:</h5>
                <p>الفنادق المدرجة على SyriaBooking.sy توافق على:</p>
                <ul>
                    <li>توفير أوصاف دقيقة وأسعار وبيانات توفر صحيحة</li>
                    <li>الحفاظ على معايير السلامة والنظافة والجودة</li>
                    <li>الوفاء بالحجوزات المؤكدة وفق الشروط المذكورة</li>
                    <li>إعلام SyriaBooking.sy والضيف بأي تغييرات لا مفر منها في الحجز</li>
                </ul>
            
                <h5>7. إخلاء المسؤولية:</h5>
                <ul>
                    <li>SyriaBooking.sy ليست مسؤولة عن حالات فشل الخدمة أو المشاكل التي يسببها الفندق، بما في ذلك الحجز الزائد أو عمليات الإلغاء أو الخدمة غير الكافية.</li>
                    <li>لسنا مسؤولين عن الإصابات الشخصية أو الخسارة أو الضرر أو السرقة التي تحدث أثناء إقامتك.</li>
                    <li>يتم توفير منصتنا ومحتواها على أساس "كما هي"، ولا نضمن خدمة غير منقطعة أو قوائم خالية من الأخطاء.</li>
                </ul>
            
                <h5>8. الملكية الفكرية:</h5>
                <p>جميع المحتويات والعلامات التجارية والشعارات والبيانات على SyriaBooking.sy هي ملكية SyriaBooking أو المرخصين لها ولا يجوز نسخها أو إعادة استخدامها أو إعادة توزيعها دون إذن.</p>
            
                <h5>9. الخصوصية:</h5>
                <p>نحن ملتزمون بحماية خصوصيتك. يرجى الرجوع إلى سياسة الخصوصية الخاصة بنا للحصول على تفاصيل كاملة حول كيفية تعاملنا مع بياناتك الشخصية.</p>
            
                <h5>10. الإنهاء:</h5>
                <p>نحتفظ بالحق في تعليق أو إنهاء الوصول إلى منصتنا لأي مستخدم وجد أنه ينتهك هذه الشروط أو يستخدم الموقع بشكل غير لائق.</p>
            
                <h5>11. القانون الحاكم:</h5>
                <p>تخضع هذه الشروط والأحكام لقوانين الجمهورية العربية السورية. سيتم التعامل مع أي نزاعات من قبل محاكم دمشق، سوريا.</p>
            
                <h5>12. معلومات الاتصال:</h5>
                <p>للأسئلة أو المخاوف بشأن هذه الشروط، يرجى الاتصال:</p>
                
                <p><strong>البريد الإلكتروني:</strong> <a href="mailto:info@syriabooking.sy">info@syriabooking.sy</a></p>
                <p><strong>الهاتف:</strong> +963-123-456789</p>
            
                <h6>شكراً لزيارتكم!</h6>
                <p>باستخدامك موقعنا أو خدماتنا، فإنك توافق على شروط هذه السياسة. يرجى مراجعتها بشكل دوري للتحديثات أو التغييرات.</p>
                        <p style="margin-top: 20px; font-weight: 500;">
                            مع أطيب التحيات،<br>
                            فريق SyriaBooking
                        </p>
            </body>
            </html>
            """
        } else {
            termsAndConditionsLabel.text = "Terms & Conditions"
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
                    h2 { font-size: 18px; font-weight: 700; margin-top: 20px; margin-bottom: 6px; color: #000000; }
                    h5 { font-size: 14px; font-weight: 600; margin-top: 14px; margin-bottom: 4px; color: #000000; }
                    h6 { font-size: 13px; font-weight: 500; margin-top: 12px; margin-bottom: 4px; color: #222222; }
                    p { margin-bottom: 8px; font-size: 13px; font-weight: 400; color: #333333; }
                    ul { padding-left: 16px; margin-top: 2px; margin-bottom: 10px; }
                    li { margin-bottom: 4px; font-size: 13px; }
                    a { color: #007AFF; text-decoration: none; font-size: 13px; font-weight: 500; }
                    strong { font-weight: 600; font-size: 14px; }
                    em { font-style: italic; color: #666666; }
                </style>
            </head>
            <body>
                <p>Welcome to SyriaBooking.sy</p>
                <p>These Terms & Conditions ("Terms") govern your use of the SyriaBooking.sy website and services...</p>
            
                <h5>1. Definitions:</h5>
                <ul>
                    <li><strong>"Platform"</strong> refers to SyriaBooking.sy website and related services.</li>
                    <li><strong>"User", "You"</strong> refers to any person browsing, using, or booking through SyriaBooking.sy.</li>
                    <li><strong>"Hotel" or "Property"</strong> means the accommodation provider listed on the platform.</li>
                    <li><strong>"Booking"</strong> means a reservation made through SyriaBooking.sy for accommodation.</li>
                </ul>
            
                <h5>2. Scope of Our Services:</h5>
                <p>SyriaBooking.sy provides an online platform for users to browse, compare, and reserve accommodations in Syria...</p>
            
                <h5>3. Booking Policy:</h5>
                <ul>
                    <li>You may book rooms through the website without any prepayment.</li>
                    <li>Your booking confirmation is sent via email or SMS after successful reservation.</li>
                    <li>Payment is made directly to the hotel at check-in, in cash or as per the hotel's accepted payment methods.</li>
                    <li>Some hotels may request a follow-up confirmation via phone or message; failure to confirm may result in cancellation.</li>
                </ul>
            
                <h5>4. Cancellation & Modification Policy:</h5>
                <ul>
                    <li>Most bookings can be modified or canceled without charge, but cancellation terms vary by property.</li>
                    <li>Please review the specific cancellation policy listed on the hotel's page before confirming your booking.</li>
                    <li>For changes or cancellations, contact the hotel directly or reach out to SyriaBooking.sy customer support.</li>
                </ul>
            
                <h5>5. User Responsibilities:</h5>
                <p>By using the platform, you agree to:</p>
                <ul>
                    <li>Provide accurate and honest information while making a booking</li>
                    <li>Abide by the rules and policies of the booked property</li>
                    <li>Arrive on time for check-in, or inform the hotel in case of delays</li>
                    <li>Not use the platform for fraudulent, illegal, or unethical purposes</li>
                </ul>
            
                <h5>6. Hotel Responsibilities:</h5>
                <p>Hotels listed on SyriaBooking.sy agree to:</p>
                <ul>
                    <li>Provide accurate descriptions, pricing, and availability</li>
                    <li>Maintain safety, cleanliness, and quality standards</li>
                    <li>Honor confirmed bookings under the stated terms</li>
                    <li>Inform SyriaBooking.sy and the guest of any unavoidable changes in booking</li>
                </ul>
            
                <h5>7. Liability Disclaimer:</h5>
                <ul>
                    <li>SyriaBooking.sy is not responsible for service failures or issues caused by the hotel, including overbooking, cancellations, or inadequate service.</li>
                    <li>We are not liable for personal injury, loss, damage, or theft incurred during your stay.</li>
                    <li>Our platform and content are provided on an "as-is" basis, and we do not guarantee uninterrupted service or error-free listings.</li>
                </ul>
            
                <h5>8. Intellectual Property:</h5>
                <p>All content, branding, logos, and data on SyriaBooking.sy are the property of SyriaBooking or its licensors and may not be copied, reused, or redistributed without permission.</p>
            
                <h5>9. Privacy:</h5>
                <p>We are committed to protecting your privacy. Please refer to our Privacy Policy for full details on how we handle your personal data.</p>
            
                <h5>10. Termination:</h5>
                <p>We reserve the right to suspend or terminate access to our platform for any user found violating these terms or using the site inappropriately.</p>
            
                <h5>11. Governing Law:</h5>
                <p>These Terms & Conditions are governed by the laws of the Syrian Arab Republic. Any disputes will be handled by the courts of Damascus, Syria.</p>
            
                <h5>12. Contact Information:</h5>
                <p>For questions or concerns about these Terms, please contact:</p>
                
                <p><strong>Email:</strong> <a href="mailto:info@syriabooking.sy">info@syriabooking.sy</a></p>
                <p><strong>Phone:</strong> +963-123-456789</p>
            
                <h6>Thank you for visiting!</h6>
                <p>By using our website or services, you consent to the terms of this policy. Please review it periodically for updates or changes.</p>
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
