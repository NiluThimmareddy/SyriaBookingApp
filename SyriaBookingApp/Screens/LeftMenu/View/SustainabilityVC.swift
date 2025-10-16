//
//  SustainabilityVC.swift
//  SyriaBookingApp
//
//  Created by toqsoft on 20/08/25.
//

import UIKit
import WebKit

class SustainabilityVC: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var bottomView: UIView!
    
    private var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebView()
        loadHTMLContent()
        scrollView.addTopShadow()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupAppNavigationBar()
    }

    private func setupWebView() {
        webView = WKWebView(frame: self.view.bounds)
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        bottomView.addSubview(webView)

        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor),
            webView.topAnchor.constraint(equalTo: bottomView.topAnchor),
            webView.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor)
        ])
    }

    private func loadHTMLContent() {
        let htmlString: String
        
        if AppSettings.shared.selectedLanguage == .arabic {
            htmlString = """
            <html lang="ar" dir="rtl">
            <head>
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <style>
                    body {
                        font-family: -apple-system;
                        padding: 20px;
                        color: #333333;
                        font-size: 13px; /* ↓ smaller font */
                        line-height: 1.3; /* ↓ tighter line gap */
                        direction: rtl;
                        text-align: right;
                    }

                    h1 {
                        font-size: 15px;
                        font-weight: 700;
                        color: #000000;
                        margin-top: 0;
                        margin-bottom: 6px;
                    }

                    h3 {
                        font-size: 14px;
                        font-weight: 600;
                        color: #000000;
                        margin-top: 16px;
                        margin-bottom: 6px;
                    }

                    p { margin-bottom: 10px; }
                    ul { padding-right: 18px; margin-bottom: 10px; }
                    li { margin-bottom: 4px; }
                    strong { font-weight: 600; font-size: 13px; }
                    em { font-style: italic; color: #666666; }
                </style>
            </head>
            <body>
                <h2>الاستدامة في SyriaBooking.sy</h2>
                <h1>دعم السفر المسؤول والضيافة المستدامة في سوريا</h1>

                <p><strong>في SyriaBooking.sy</strong> نؤمن بأن السفر يجب أن يكون ممتعاً وفي الوقت نفسه محترماً — للبيئة، وللمجتمعات المحلية، وللتراث الثقافي. نحن ملتزمون بتعزيز ممارسات السياحة المستدامة التي تعود بالفائدة على المسافرين وعلى وطننا سوريا.</p>

                <h3>التزامنا بمستقبل أكثر اخضراراً</h3>

                <h3>١. تعزيز الفنادق الصديقة للبيئة</h3>
                <p>نسلط الضوء وندعم أماكن الإقامة التي:</p>
                <ul>
                    <li>تستخدم الطاقة المتجددة أو ممارسات توفير الطاقة</li>
                    <li>تقلل من استخدام البلاستيك لمرة واحدة</li>
                    <li>تطبق برامج تقليل النفايات وإعادة التدوير</li>
                    <li>تحافظ على المياه والموارد المحلية</li>
                </ul>
                <p>ابحث عن شارة <em>“الإقامة الخضراء”</em> على القوائم التي تلبي معايير الاستدامة.</p>

                <h3>٢. دعم المجتمعات المحلية</h3>
                <p>من خلال ربط المسافرين بالفنادق وبيوت الضيافة المملوكة محلياً، نضمن أن السياحة تدعم بشكل مباشر العائلات والأعمال والحرفيين. وهذا يعزز النمو الشامل والحفاظ على الثقافة.</p>

                <h3>٣. تشجيع السفر المسؤول</h3>
                <p>نقوم بتثقيف مستخدمينا من خلال النصائح والأدلة حول كيفية:</p>
                <ul>
                    <li>احترام التقاليد والثقافة المحلية</li>
                    <li>اختيار وسائل النقل منخفضة الأثر</li>
                    <li>تجنب السياحة المفرطة في المناطق الحساسة</li>
                    <li>ترك الأماكن أفضل مما وجدوها</li>
                </ul>

                <h3>٤. تمكين الفنادق من ممارسات أكثر استدامة</h3>
                <p>نعمل مع شركائنا من الفنادق لاعتماد تغييرات بسيطة ولكنها فعّالة مثل:</p>
                <ul>
                    <li>استخدام الإضاءة الموفرة للطاقة</li>
                    <li>تقديم وسائل راحة قابلة لإعادة الاستخدام</li>
                    <li>تقليل هدر الطعام</li>
                    <li>تدريب الموظفين على معايير الاستدامة</li>
                </ul>

                <h3>معاً نحو مستقبل أفضل</h3>
                <p>كل حجز يتم عبر SyriaBooking.sy يساهم في رؤيتنا لصناعة سفر أكثر استدامة وحيوية في سوريا. سواء جئت للترفيه أو العمل، ندعوك للسفر بوعي واحترام ومسؤولية.</p>

                <p><strong>معاً لنحافظ على جمال سوريا — اليوم وغداً.</strong></p>

                <p><em>خيارات مستدامة. تجارب أصيلة. سوريا أفضل.</em></p>
            </body>
            </html>
            """
        } else {
            htmlString = """
            <html lang="en" dir="ltr">
            <head>
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <style>
                    body {
                        font-family: -apple-system;
                        padding: 20px;
                        color: #333333;
                        font-size: 13px; /* ↓ smaller font */
                        line-height: 1.3; /* ↓ tighter line gap */
                        direction: ltr;
                        text-align: left;
                    }

                    h1 {
                        font-size: 15px;
                        font-weight: 700;
                        color: #000000;
                        margin-top: 0;
                        margin-bottom: 6px;
                    }

                    h3 {
                        font-size: 14px;
                        font-weight: 600;
                        color: #000000;
                        margin-top: 16px;
                        margin-bottom: 6px;
                    }

                    p { margin-bottom: 10px; }
                    ul { padding-left: 18px; margin-bottom: 10px; }
                    li { margin-bottom: 4px; }
                    strong { font-weight: 600; font-size: 13px; }
                    em { font-style: italic; color: #666666; }
                </style>
            </head>
            <body>
                <h2>Sustainability at SyriaBooking.sy</h2>
                <h1>Supporting Responsible Travel and Sustainable Hospitality in Syria</h1>

                <p><strong>At SyriaBooking.sy</strong>, we believe travel should not only be enjoyable but also respectful — of the environment, local communities, and cultural heritage. We are committed to promoting sustainable tourism practices that benefit both travelers and our beloved Syria.</p>

                <h3>Our Commitment to a Greener Future</h3>

                <h3>1. Promoting Eco-Friendly Hotels</h3>
                <p>We actively highlight and promote accommodations that:</p>
                <ul>
                    <li>Use renewable energy or energy-saving practices</li>
                    <li>Minimize single-use plastics</li>
                    <li>Implement waste reduction and recycling programs</li>
                    <li>Conserve water and local resources</li>
                </ul>
                <p>Look for the <em>“Eco Stay”</em> badge on listings that meet sustainability criteria.</p>

                <h3>2. Supporting Local Communities</h3>
                <p>By connecting travelers with locally owned hotels and guesthouses, we help ensure that tourism directly supports local families, businesses, and artisans. This promotes inclusive growth and cultural preservation.</p>

                <h3>3. Encouraging Responsible Travel</h3>
                <p>We educate our users through tips and travel guides on how to:</p>
                <ul>
                    <li>Respect local traditions and culture</li>
                    <li>Choose low-impact transportation options</li>
                    <li>Avoid over-tourism in sensitive regions</li>
                    <li>Leave places better than they found them</li>
                </ul>

                <h3>4. Empowering Hotels Towards Greener Practices</h3>
                <p>We work with our hotel partners to adopt simple but impactful changes, including:</p>
                <ul>
                    <li>Switching to energy-efficient lighting</li>
                    <li>Offering reusable amenities</li>
                    <li>Reducing food waste</li>
                    <li>Training staff on sustainability standards</li>
                </ul>

                <h3>Let’s Build a Better Future Together</h3>
                <p>Every booking made through SyriaBooking.sy contributes to our vision of a more sustainable and vibrant travel industry in Syria. Whether you’re visiting for leisure or business, we invite you to travel consciously, respectfully, and responsibly.</p>

                <p><strong>Together, let’s preserve the beauty of Syria — for today and tomorrow.</strong></p>

                <p><em>Sustainable choices. Authentic experiences. A better Syria.</em></p>
            </body>
            </html>
            """
        }
        webView.loadHTMLString(htmlString, baseURL: nil)
    }
    
}

