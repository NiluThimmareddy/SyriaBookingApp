//
//  SustainabilityVC.swift
//  SyriaBookingApp
//
//  Created by toqsoft on 20/08/25.
//

import UIKit
import WebKit

class SustainabilityVC: UIViewController, WKNavigationDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var sustainabilityTitleLabel: UILabel!
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
            sustainabilityTitleLabel.text = "الاستدامة"
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
                <h2>الاستدامة في SyriaBooking.sy</h2>
                <p><strong>دعم السفر المسؤول والضيافة المستدامة في سوريا</strong></p>
            
                <p><strong>في SyriaBooking.sy</strong> نؤمن بأن السفر يجب أن يكون ممتعاً وفي الوقت نفسه محترماً — للبيئة، وللمجتمعات المحلية، وللتراث الثقافي. نحن ملتزمون بتعزيز ممارسات السياحة المستدامة التي تعود بالفائدة على المسافرين وعلى وطننا سوريا.</p>
            
                <h5>١. تعزيز الفنادق الصديقة للبيئة</h5>
                <p>نسلط الضوء وندعم أماكن الإقامة التي:</p>
                <ul>
                    <li>تستخدم الطاقة المتجددة أو ممارسات توفير الطاقة</li>
                    <li>تقلل من استخدام البلاستيك لمرة واحدة</li>
                    <li>تطبق برامج تقليل النفايات وإعادة التدوير</li>
                    <li>تحافظ على المياه والموارد المحلية</li>
                </ul>
                <p>ابحث عن شارة <em>"الإقامة الخضراء"</em> على القوائم التي تلبي معايير الاستدامة.</p>
            
                <h5>٢. دعم المجتمعات المحلية</h5>
                <p>من خلال ربط المسافرين بالفنادق وبيوت الضيافة المملوكة محلياً، نضمن أن السياحة تدعم بشكل مباشر العائلات والأعمال والحرفيين. وهذا يعزز النمو الشامل والحفاظ على الثقافة.</p>
            
                <h5>٣. تشجيع السفر المسؤول</h5>
                <p>نقوم بتثقيف مستخدمينا من خلال النصائح والأدلة حول كيفية:</p>
                <ul>
                    <li>احترام التقاليد والثقافة المحلية</li>
                    <li>اختيار وسائل النقل منخفضة الأثر</li>
                    <li>تجنب السياحة المفرطة في المناطق الحساسة</li>
                    <li>ترك الأماكن أفضل مما وجدوها</li>
                </ul>
            
                <h5>٤. تمكين الفنادق من ممارسات أكثر استدامة</h5>
                <p>نعمل مع شركائنا من الفنادق لاعتماد تغييرات بسيطة ولكنها فعّالة مثل:</p>
                <ul>
                    <li>استخدام الإضاءة الموفرة للطاقة</li>
                    <li>تقديم وسائل راحة قابلة لإعادة الاستخدام</li>
                    <li>تقليل هدر الطعام</li>
                    <li>تدريب الموظفين على معايير الاستدامة</li>
                </ul>
            
                <h5>معاً نحو مستقبل أفضل</h5>
                <p>كل حجز يتم عبر SyriaBooking.sy يساهم في رؤيتنا لصناعة سفر أكثر استدامة وحيوية في سوريا. سواء جئت للترفيه أو العمل، ندعوك للسفر بوعي واحترام ومسؤولية.</p>
            
                <p><strong>معاً لنحافظ على جمال سوريا — اليوم وغداً.</strong></p>
            
                <p><em>خيارات مستدامة. تجارب أصيلة. سوريا أفضل.</em></p>
            </body>
            </html>
            """
        } else {
            sustainabilityTitleLabel.text = "Sustainability"
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
                <h2>Sustainability at SyriaBooking.sy</h2>
                <p><strong>Supporting Responsible Travel and Sustainable Hospitality in Syria</strong></p>
            
                <p><strong>At SyriaBooking.sy</strong>, we believe travel should not only be enjoyable but also respectful — of the environment, local communities, and cultural heritage. We are committed to promoting sustainable tourism practices that benefit both travelers and our beloved Syria.</p>
            
                <h5>1. Promoting Eco-Friendly Hotels</h5>
                <p>We actively highlight and promote accommodations that:</p>
                <ul>
                    <li>Use renewable energy or energy-saving practices</li>
                    <li>Minimize single-use plastics</li>
                    <li>Implement waste reduction and recycling programs</li>
                    <li>Conserve water and local resources</li>
                </ul>
                <p>Look for the <em>"Eco Stay"</em> badge on listings that meet sustainability criteria.</p>
            
                <h5>2. Supporting Local Communities</h5>
                <p>By connecting travelers with locally owned hotels and guesthouses, we help ensure that tourism directly supports local families, businesses, and artisans. This promotes inclusive growth and cultural preservation.</p>
            
                <h5>3. Encouraging Responsible Travel</h5>
                <p>We educate our users through tips and travel guides on how to:</p>
                <ul>
                    <li>Respect local traditions and culture</li>
                    <li>Choose low-impact transportation options</li>
                    <li>Avoid over-tourism in sensitive regions</li>
                    <li>Leave places better than they found them</li>
                </ul>
            
                <h5>4. Empowering Hotels Towards Greener Practices</h5>
                <p>We work with our hotel partners to adopt simple but impactful changes, including:</p>
                <ul>
                    <li>Switching to energy-efficient lighting</li>
                    <li>Offering reusable amenities</li>
                    <li>Reducing food waste</li>
                    <li>Training staff on sustainability standards</li>
                </ul>
            
                <h5>Let's Build a Better Future Together</h5>
                <p>Every booking made through SyriaBooking.sy contributes to our vision of a more sustainable and vibrant travel industry in Syria. Whether you're visiting for leisure or business, we invite you to travel consciously, respectfully, and responsibly.</p>
            
                <p><strong>Together, let's preserve the beauty of Syria — for today and tomorrow.</strong></p>
            
                <p><em>Sustainable choices. Authentic experiences. A better Syria.</em></p>
            </body>
            </html>
            """
        }
        
        webView.loadHTMLString(htmlString, baseURL: nil)
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
