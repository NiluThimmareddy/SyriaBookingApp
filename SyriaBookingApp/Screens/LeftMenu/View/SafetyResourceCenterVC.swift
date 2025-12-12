//
//  SafetyResourceCenterVC.swift
//  SyriaBookingApp
//
//  Created by toqsoft on 20/08/25.
//

import UIKit
import WebKit

class SafetyResourceCenterVC: UIViewController, WKNavigationDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var safetyResourceCenterTitleLabel: UILabel!
    @IBOutlet weak var redefiningTravelDescriptionLabel: UILabel!
    @IBOutlet weak var followLinksView: UIView!
    
    private var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupWebView()
        setupSocialMediaView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupAppNavigationBar()
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
            safetyResourceCenterTitleLabel.text = "مركز موارد السلامة"
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
                    h1 { font-size: 18px; font-weight: 700; margin-top: 0; margin-bottom: 8px; color: #000000; }
                    h3 { font-size: 14px; font-weight: 600; margin-top: 16px; margin-bottom: 6px; color: #000000; }
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
                <h1>سلامتك هي أولويتنا</h1>
            
                <p><strong>في SyriaBooking.sy</strong>، راحة بالك هي جوهر كل ما نقوم به. نحن ملتزمون بتوفير تجربة سفر آمنة ومطمئنة منذ لحظة الحجز وحتى تسجيل المغادرة.</p>
            
                <p>يقدم مركز موارد السلامة هذا إرشادات ودعماً أساسياً لمساعدتك على السفر بثقة في جميع أنحاء سوريا.</p>
            
                <h5>١. أمان الحجز والخصوصية</h5>
                <ul>
                    <li><strong>فنادق موثقة فقط:</strong> جميع العقارات تمر بعملية تحقق صارمة قبل النشر.</li>
                    <li><strong>منصة آمنة:</strong> يتم حماية بياناتك باستخدام بروتوكولات التشفير والمعايير العالمية.</li>
                    <li><strong>بدون دفعات مقدمة:</strong> من خلال نظام <em>"الدفع عند الوصول"</em>، لست بحاجة إلى إدخال بيانات الدفع عبر الإنترنت.</li>
                </ul>
            
                <h5>٢. تدابير السلامة في الفنادق</h5>
                <p>نشجع شركاء الفنادق على تبني الممارسات التالية:</p>
                <ul>
                    <li>تنظيف الغرف وتعقيمها يومياً</li>
                    <li>توافر صناديق الإسعافات الأولية</li>
                    <li>توفير معلومات الاتصال في حالات الطوارئ</li>
                    <li>موظفون مدربون للسلامة والاستجابة للحالات الطارئة</li>
                    <li>بروتوكولات الصحة والنظافة خاصة في الأماكن كثيرة الاستخدام</li>
                </ul>
                <p>ابحث عن شارة <em>"معتمد للسلامة"</em> للفنادق التي تقدم المزيد.</p>
            
                <h5>٣. مسؤولية المسافر</h5>
                <ul>
                    <li>اتبع إرشادات الصحة والسلامة المحلية</li>
                    <li>احترم قوانين الفندق وتعليمات الموظفين</li>
                    <li>احمل بطاقة هوية ووثائق سفر صالحة</li>
                    <li>احتفظ بأرقام الطوارئ في متناول يدك</li>
                </ul>
            
                <h5>٤. في حالة الطوارئ</h5>
                <ul>
                    <li><strong>الشرطة المحلية:</strong> 112</li>
                    <li><strong>الإسعاف:</strong> 110</li>
                    <li><strong>البريد الإلكتروني:</strong> info@syriabooking.sy</li>
                    <li><strong>الهاتف:</strong> +963-123-456789</li>
                </ul>
            
                <h5>٥. نصائح السفر لسوريا</h5>
                <ul>
                    <li>التزم بالمناطق والفنادق المعروفة</li>
                    <li>تجنب التنقل ليلاً في أماكن غير مألوفة</li>
                    <li>حافظ على مقتنياتك الثمينة بأمان</li>
                    <li>استخدم خزائن الفنادق متى ما كان ذلك ممكناً</li>
                    <li>شارك خط سير رحلتك مع العائلة أو الأصدقاء</li>
                </ul>
            
                <h5>هل تحتاج للمساعدة؟</h5>
                <p>إذا كان لديك أي قلق قبل أو أثناء أو بعد إقامتك، فإن فريق خدمة العملاء لدينا هنا لمساعدتك.</p>
                <p><strong>متاحون على مدار الساعة</strong> لضمان سلامتك ورضاك.</p>
            </body>
            </html>
            """
        } else {
            safetyResourceCenterTitleLabel.text = "Safety Resource Center"
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
                    h1 { font-size: 18px; font-weight: 700; margin-top: 0; margin-bottom: 8px; color: #000000; }
                    h3 { font-size: 14px; font-weight: 600; margin-top: 16px; margin-bottom: 6px; color: #000000; }
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
                <h1>Your Safety Is Our Priority</h1>
            
                <p><strong>At SyriaBooking.sy</strong>, your peace of mind is at the heart of everything we do. We are committed to providing a safe, secure, and informed travel experience — from the moment you book until you check out.</p>
            
                <p>This Safety Resource Center offers essential guidance and support to help you travel confidently across Syria.</p>
            
                <h5>1. Booking Safety & Privacy</h5>
                <ul>
                    <li><strong>Verified Hotels Only:</strong> All listed properties on our platform go through a strict verification process before being published.</li>
                    <li><strong>Secure Platform:</strong> Your data is protected using industry-standard encryption and privacy protocols.</li>
                    <li><strong>No Advance Payment Required:</strong> With our "Pay on Arrival" system, you don't need to enter any payment details online.</li>
                </ul>
            
                <h5>2. Hotel Safety Measures</h5>
                <p>We encourage our hotel partners to adopt and maintain the following safety practices:</p>
                <ul>
                    <li>Daily room cleaning and sanitization</li>
                    <li>On-site availability of first aid kits</li>
                    <li>Emergency contact information readily available</li>
                    <li>Trained staff for guest safety and emergency response</li>
                    <li>Health & hygiene protocols especially for high-contact areas</li>
                </ul>
                <p>Look for the <em>"Safety Certified"</em> badge on hotels that go the extra mile.</p>
            
                <h5>3. Traveler Responsibility</h5>
                <ul>
                    <li>Follow local health, safety, and travel guidelines</li>
                    <li>Respect hotel rules and staff instructions</li>
                    <li>Carry proper ID and travel documents</li>
                    <li>Keep emergency numbers accessible</li>
                </ul>
            
                <h5>4. In Case of Emergency</h5>
                <ul>
                    <li><strong>Local Police:</strong> 112</li>
                    <li><strong>Medical Emergency:</strong> 110</li>
                    <li><strong>Email:</strong> info@syriabooking.sy</li>
                    <li><strong>Phone:</strong> +963-123-456789</li>
                </ul>
            
                <h5>5. Travel Tips for Syria</h5>
                <ul>
                    <li>Stick to well-known destinations and hotel areas</li>
                    <li>Avoid traveling late at night in unfamiliar locations</li>
                    <li>Keep valuables secure and avoid displaying large amounts of cash</li>
                    <li>Use hotel safes whenever possible</li>
                    <li>Share your travel itinerary with family or friends</li>
                </ul>
            
                <h5>Need Help?</h5>
                <p>If you have any concerns before, during, or after your stay, our customer care team is here to support you.</p>
                <p><strong>We're available 24/7</strong> to ensure your safety and satisfaction.</p>
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
