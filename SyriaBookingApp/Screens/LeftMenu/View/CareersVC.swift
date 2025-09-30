//
//  CareersVC.swift
//  NewProject
//
//  Created by Yarramsetti Yedukondalu on 06/08/25.
//

import UIKit
import WebKit

class CareersVC: UIViewController {
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var insideScrollView: UIView!
    
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
        backView.addSubview(webView)
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: backView.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: backView.trailingAnchor),
            webView.topAnchor.constraint(equalTo: backView.topAnchor),
            webView.bottomAnchor.constraint(equalTo: backView.bottomAnchor)
        ])
    }
    
    private func loadHTMLContent() {
        let htmlString: String
        
        if AppSettings.shared.selectedLanguage == .arabic {
            // ✅ Arabic version (RTL)
            htmlString = """
            <html lang="ar" dir="rtl">
            <head>
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <style>
                    body {
                        font-family: -apple-system;
                        padding: 20px;
                        color: #333333;
                        font-size: 16px;
                        line-height: 1.8;
                        direction: rtl;
                        text-align: right;
                    }
                    h1 { font-size: 22px; font-weight: 700; margin-bottom: 10px; text-align: right; }
                    h2 { font-size: 20px; font-weight: 600; margin-top: 15px; margin-bottom: 10px; text-align: right; }
                    h3 { font-size: 18px; font-weight: 600; margin-top: 20px; margin-bottom: 8px; text-align: right; }
                    p { margin-bottom: 14px; text-align: right; }
                    ul { padding-right: 20px; }
                    li { margin-bottom: 8px; }
                    strong { font-weight: 600; font-size: 17px; }
                    em { font-style: italic; color: #666666; }
                </style>
            </head>
            <body>
                <h1>الوظائف في SyriaBooking.sy</h1>
                <h2>انضم إلى الفريق وراء منصة حجز الفنادق الرائدة في سوريا</h2>
                
                <p><strong>في SyriaBooking.sy</strong> نحن في مهمة لتحويل طريقة استكشاف وتجربة سوريا — بجعل السفر أبسط، وأذكى، وأكثر سهولة للجميع. نحن نبني المنصة الأولى لحجز الفنادق في البلاد، ونبحث عن أشخاص شغوفين لينموا معنا.</p>
                
                <p>سواء كنت خبيرًا تقنيًا، أو بطلًا في خدمة العملاء، أو راوي قصص مبدعًا، أو استراتيجيًا في الأعمال — إذا كنت تؤمن بالابتكار والنزاهة والتأثير، ستجد مكانك هنا.</p>
                
                <h3>لماذا تعمل معنا؟</h3>
                
                <h3>١. الابتكار محليًا، والتأثير وطنيًا</h3>
                <p>كن جزءًا من شركة تقنية رائدة تُحدث تغييرًا حقيقيًا في صناعة السفر والسياحة السورية.</p>
                
                <h3>٢. ثقافة تعاونية وداعمة</h3>
                <p>نحن نقدر العمل الجماعي والتواصل المفتوح والنمو المشترك. صوتك له قيمة هنا.</p>
                
                <h3>٣. فرص نمو مهني</h3>
                <p>نحن ننمو بسرعة — وكذلك أنت. تعلم، قد، وارتقِ بمسارك المهني إلى المستوى التالي.</p>
                
                <h3>٤. العمل من أجل هدف</h3>
                <p>عملك سيساعد المسافرين مباشرة، ويدعم الأعمال المحلية، ويعرض جمال سوريا للعالم.</p>
                
                <h3>لم تجد وظيفة تناسبك؟</h3>
                <p>نحن دائمًا منفتحون لسماع من المحترفين الشغوفين. أرسل سيرتك الذاتية على أي حال!</p>
                
                <h3>كيف تتقدم بطلب؟</h3>
                <p>أرسل سيرتك الذاتية ومقدمة مختصرة إلى: <strong>careers@syriabooking.sy</strong><br>
                الموضوع: [المسمى الوظيفي] – طلب التوظيف – اسمك</p>
                
                <h3>هل أنت مستعد لبناء مستقبل السفر في سوريا؟</h3>
                <p><strong>كن جزءًا من شيء مؤثر.<br>انضم إلى SyriaBooking.sy. السفر يبدأ هنا.</strong></p>
            </body>
            </html>
            """
        } else {
            // ✅ English version (LTR)
            htmlString = """
            <html lang="en" dir="ltr">
            <head>
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <style>
                    body {
                        font-family: -apple-system;
                        padding: 20px;
                        color: #333333;
                        font-size: 16px;
                        line-height: 1.6;
                        direction: ltr;
                        text-align: left;
                    }
                    h1 { font-size: 22px; font-weight: 700; margin-bottom: 10px; text-align: left; }
                    h2 { font-size: 20px; font-weight: 600; margin-top: 15px; margin-bottom: 10px; text-align: left; }
                    h3 { font-size: 18px; font-weight: 600; margin-top: 20px; margin-bottom: 8px; text-align: left; }
                    p { margin-bottom: 14px; text-align: left; }
                    ul { padding-left: 20px; }
                    li { margin-bottom: 8px; }
                    strong { font-weight: 600; font-size: 17px; }
                    em { font-style: italic; color: #666666; }
                </style>
            </head>
            <body>
                <h1>Careers at SyriaBooking.sy</h1>
                <h2>Join the Team Behind Syria’s Leading Hotel Booking Platform</h2>
                
                <p><strong>At SyriaBooking.sy</strong>, we’re on a mission to transform how people explore and experience Syria — by making travel simpler, smarter, and more accessible for everyone. We’re building the country’s go-to platform for hotel bookings, and we’re looking for passionate individuals to grow with us.</p>
                
                <p>Whether you’re a tech expert, customer service champion, creative storyteller, or business strategist — if you believe in innovation, integrity, and impact, you’ll feel at home here.</p>
                
                <h3>Why Work With Us?</h3>
                
                <h3>1. Innovate Locally, Impact Nationally</h3>
                <p>Be part of a pioneering tech company creating real change in the Syrian travel and tourism industry.</p>
                
                <h3>2. Collaborative & Supportive Culture</h3>
                <p>We value teamwork, open communication, and mutual growth. Your voice matters here.</p>
                
                <h3>3. Career Growth Opportunities</h3>
                <p>We’re growing fast — and so will you. Learn, lead, and take your career to the next level.</p>
                
                <h3>4. Work With Purpose</h3>
                <p>Your work will directly help travelers, support local businesses, and showcase the beauty of Syria to the world.</p>
                
                <h3>Didn’t see a role that fits?</h3>
                <p>We’re always open to hearing from passionate professionals. Send us your CV anyway!</p>
                
                <h3>How to Apply?</h3>
                <p>Email your CV and a brief introduction to: <strong>careers@syriabooking.sy</strong><br>
                Subject: [Job Title] – Application – Your Name</p>
                
                <h3>Ready to Build the Future of Travel in Syria?</h3>
                <p><strong>Be part of something impactful.<br>Join SyriaBooking.sy. Travel Starts Here.</strong></p>
            </body>
            </html>
            """
        }
        
        webView.loadHTMLString(htmlString, baseURL: nil)
    }
}
