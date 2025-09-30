//
//  HowItsWorkVC.swift
//  NewProject
//
//  Created by Yarramsetti Yedukondalu on 06/08/25.
//

import UIKit
import WebKit

class HowItsWorkVC: UIViewController {
    
    @IBOutlet weak var topView: UILabel!
    @IBOutlet weak var designView: UIView!
    @IBOutlet weak var howitWorksButtonIcon: UIButton!
    
    weak var delegate: YourNotificationVCDelegate?
    private var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebView()
        loadHTMLContent()
        howitWorksButtonIcon.setImage(UIImage(systemName: "lightbulb"), for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupAppNavigationBar()
      
    }
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    // MARK: - Setup WebView
    private func setupWebView() {
        webView = WKWebView(frame: .zero)
        webView.translatesAutoresizingMaskIntoConstraints = false
        designView.addSubview(webView)
        
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: designView.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: designView.trailingAnchor),
            webView.topAnchor.constraint(equalTo: designView.topAnchor),
            webView.bottomAnchor.constraint(equalTo: designView.bottomAnchor)
        ])
    }
    
    private func loadHTMLContent() {
        let htmlString: String
        
        if AppSettings.shared.selectedLanguage == .arabic {
            // ✅ Arabic version
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
                    h1 { font-size: 22px; font-weight: 700; margin-bottom: 12px; color: #000; }
                    h2 { font-size: 19px; font-weight: 600; margin-bottom: 12px; color: #111; }
                    h3 { font-size: 18px; font-weight: 600; margin-top: 20px; margin-bottom: 8px; color: #000; }
                    p { margin-bottom: 14px; }
                    strong { font-weight: 600; font-size: 17px; }
                    em { font-style: italic; color: #666; }
                </style>
            </head>
            <body>
                <h1>كيف تعمل</h1>
                <h2>احجز إقامتك في سوريا بسهولة</h2>
                <p>في <strong>SyriaBooking.sy</strong> جعلنا تجربة حجز الفنادق بسيطة، وآمنة، ومرنة.
                مع ميزة <em>“الدفع عند الوصول”</em> يمكنك التخطيط لإقامتك بثقة — بدون أي دفعات مقدمة!</p>
                
                <h3>١. ابحث عن الفنادق</h3>
                <p>استخدم محرك البحث القوي لدينا لاستكشاف الفنادق في جميع أنحاء سوريا...</p>
                
                <h3>٢. قارن واختر</h3>
                <p>تصفح ملفات الفنادق التفصيلية، صور النزلاء، المرافق، وأنواع الغرف...</p>
                
                <h3>٣. احجز فوراً — بدون دفع مسبق</h3>
                <p>اختر غرفتك، أدخل بياناتك، ثم اضغط <strong>“احجز الآن”</strong>...</p>
                
                <h3>٤. استلم التأكيد</h3>
                <p>بعد الحجز ستتلقى تأكيداً يتضمن تفاصيل الفندق...</p>
                
                <h3>٥. ادفع في الفندق</h3>
                <p>عند وصولك إلى الفندق، أظهر تأكيد الحجز وادفع مباشرة...</p>
                
                <p><strong>SyriaBooking — شريكك الموثوق للسفر في سوريا.</strong></p>
            </body>
            </html>
            """
        } else {
            // ✅ English version
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
                    h1 { font-size: 22px; font-weight: 700; margin-bottom: 12px; color: #000; }
                    h2 { font-size: 19px; font-weight: 600; margin-bottom: 12px; color: #111; }
                    h3 { font-size: 18px; font-weight: 600; margin-top: 20px; margin-bottom: 8px; color: #000; }
                    p { margin-bottom: 14px; }
                    strong { font-weight: 600; font-size: 17px; }
                    em { font-style: italic; color: #666; }
                </style>
            </head>
            <body>
                <h1>How It Works</h1>
                <h2>Book Your Stay in Syria with Ease</h2>
                <p>At <strong>SyriaBooking.sy</strong>, we’ve made your hotel booking experience simple, secure, and flexible.
                With our <em>“Pay on Arrival”</em> feature, you can plan your stay with confidence — no prepayment required!</p>
                
                <h3>1. Search for Hotels</h3>
                <p>Use our powerful search engine to explore hotels across Syria...</p>
                
                <h3>2. Compare & Choose</h3>
                <p>Browse detailed hotel profiles, real guest photos, amenities, and room types...</p>
                
                <h3>3. Book Instantly — No Payment Required</h3>
                <p>Select your room, enter your details, and click <strong>“Book Now”</strong>...</p>
                
                <h3>4. Receive Confirmation</h3>
                <p>Once you book, you’ll receive a booking confirmation with all your hotel details...</p>
                
                <h3>5. Pay at the Hotel</h3>
                <p>Arrive at your hotel, show your booking confirmation, and pay directly...</p>
                
                <p><strong>SyriaBooking — Your trusted travel partner in Syria.</strong></p>
            </body>
            </html>
            """
        }
        
        webView.loadHTMLString(htmlString, baseURL: nil)
    }

}
