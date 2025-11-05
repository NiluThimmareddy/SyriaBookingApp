//
//  TermsAndConditionsVC.swift
//  SyriaBookingApp
//
//  Created by toqsoft on 19/08/25.
//

import UIKit
import WebKit

class TermsAndConditionsVC: UIViewController {

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var termsAndConditionsTitleLabel: UILabel!
    @IBOutlet weak var termsAndConditionsLabel: UILabel!
    @IBOutlet weak var redefiningTravelDescriptionLabel: UILabel!
    
    
    private var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()

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
        loadHTMLContent()
        if AppSettings.shared.selectedLanguage == .arabic {
            termsAndConditionsTitleLabel.text = "الشروط والأحكام"
            termsAndConditionsTitleLabel.textAlignment = .center
        } else {
            termsAndConditionsTitleLabel.text = "Terms and Conditions"
            termsAndConditionsTitleLabel.textAlignment = .center
        }

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
                    <li><strong>“المنصة”</strong> تشير إلى موقع SyriaBooking.sy والخدمات المرتبطة به.</li>
                    <li><strong>“المستخدم” أو “أنت”</strong> يشير إلى أي شخص يقوم بتصفح أو استخدام أو الحجز عبر SyriaBooking.sy.</li>
                    <li><strong>“الفندق” أو “مكان الإقامة”</strong> يعني مزود الإقامة المدرج على المنصة.</li>
                    <li><strong>“الحجز”</strong> يعني حجز إقامة تم عبر SyriaBooking.sy.</li>
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

                <h6>شكراً لزيارتكم!</h6>
                <p>باستخدامك موقعنا أو خدماتنا، فإنك توافق على شروط هذه السياسة. يرجى مراجعتها بشكل دوري للتحديثات أو التغييرات.</p>

                <p><strong>للتواصل:</strong> <a href="mailto:info@syriabooking.sy">info@syriabooking.sy</a></p>
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
                <p>These Terms & Conditions (“Terms”) govern your use of the SyriaBooking.sy website and services...</p>

                <h5>1. Definitions:</h5>
                <ul>
                    <li><strong>“Platform”</strong> refers to SyriaBooking.sy website and related services.</li>
                    <li><strong>“User”, “You”</strong> refers to any person browsing, using, or booking through SyriaBooking.sy.</li>
                    <li><strong>“Hotel” or “Property”</strong> means the accommodation provider listed on the platform.</li>
                    <li><strong>“Booking”</strong> means a reservation made through SyriaBooking.sy for accommodation.</li>
                </ul>

                <h5>2. Scope of Our Services:</h5>
                <p>SyriaBooking.sy provides an online platform for users to browse, compare, and reserve accommodations in Syria...</p>

                <h5>3. Booking Policy:</h5>
                <ul>
                    <li>You may book rooms through the website without any prepayment.</li>
                    <li>Your booking confirmation is sent via email or SMS after successful reservation.</li>
                    <li>Payment is made directly to the hotel at check-in, in cash or as per the hotel’s accepted payment methods.</li>
                    <li>Some hotels may request a follow-up confirmation via phone or message; failure to confirm may result in cancellation.</li>
                </ul>

                <h6>Thank you for visiting!</h6>
                <p>By using our website or services, you consent to the terms of this policy. Please review it periodically for updates or changes.</p>

                <p><strong>Contact:</strong> <a href="mailto:info@syriabooking.sy">info@syriabooking.sy</a></p>
            </body>
            </html>
            """
        }
        
        webView.loadHTMLString(htmlString, baseURL: nil)
    }

}
