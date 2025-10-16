

import UIKit
import WebKit

class AboutUsVC: UIViewController {

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var aboutUsTitleLabel: UILabel!
    
    private var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebView()
        loadHTMLContent()
        if AppSettings.shared.selectedLanguage == .arabic {
            aboutUsTitleLabel.text = "معلومات عنا" 
            aboutUsTitleLabel.textAlignment = .center
        } else {
            aboutUsTitleLabel.text = "About Us"
            aboutUsTitleLabel.textAlignment = .center
        }
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
            <html lang="ar" dir="ltr">
            <head>
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <style>
                    body {
                        font-family: -apple-system;
                        padding: 20px;
                        color: #333333;
                        font-size: 13px; /* ↓ smaller font */
                        line-height: 1.3; /* ↓ tighter line spacing */
                        direction: ltr;
                        text-align: left;
                    }
                    h1 { font-size: 16px; font-weight: 700; margin-bottom: 6px; text-align: left; }
                    h2 { font-size: 15px; font-weight: 600; margin-top: 10px; margin-bottom: 6px; text-align: left; }
                    h3 { font-size: 14px; font-weight: 600; margin-top: 12px; margin-bottom: 5px; text-align: left; }
                    p { margin-bottom: 8px; text-align: left; }
                    ul { padding-left: 16px; margin-bottom: 8px; }
                    li { margin-bottom: 4px; }
                    strong { font-weight: 600; font-size: 13px; }
                    em { font-style: italic; color: #666666; }
                </style>
            </head>
            <body>
                <h1>مرحباً بكم في SyriaBooking</h1>
                <h2>نظام حجز الفنادق</h2>

                <p><strong>شريكك الموثوق لحجز الفنادق في جميع أنحاء سوريا</strong></p>

                <p>
                    في SyriaBooking.sy، نحن نعيد تعريف السفر والضيافة داخل سوريا من خلال تقديم تجربة حجز فنادق سهلة،
                    شفافة وآمنة لكل من المسافرين المحليين والدوليين. تأسست منصتنا بهدف دعم القطاع السياحي والاقتصادي
                    في سوريا، من خلال توفير مجموعة واسعة من الفنادق والمنتجعات — من الإقامات الاقتصادية إلى تجارب
                    فاخرة — في جميع أنحاء البلاد.
                </p>

                <h3>1. مجموعة واسعة من العقارات</h3>
                <p>
                    سواء كنت تزور دمشق أو حلب أو اللاذقية أو طرطوس أو حمص أو أي مدينة سورية أخرى، فقد تعاونّا مع فنادق
                    موثوقة لنقدم لك خيارات إقامة مريحة وموثوقة.
                </p>

                <h3>2. احجز الآن، ادفع عند الوصول</h3>
                <p>
                    لا حاجة لبطاقات الائتمان أو الدفع المسبق. فقط ابحث، اختر واحجز إقامتك — وادفع مباشرة عند وصولك إلى الفندق.
                </p>

                <h3>3. عملية حجز سهلة</h3>
                <p>
                    مصممة للبساطة. ابحث عن الفنادق حسب المدينة، التواريخ أو الميزانية وأكمل حجزك ببضع نقرات فقط.
                </p>

                <h3>4. معلومات حقيقية، بلا مفاجآت</h3>
                <p>
                    نحن نقدم وصفًا تفصيليًا للفنادق، صورًا حقيقية، وسائل الراحة، تقييمات الضيوف، وخرائط المواقع — لتعرف دائمًا ما تتوقعه.
                </p>

                <h3>5. خبرة محلية</h3>
                <p>
                    نحن منصة سورية تفهم السوق المحلي، الثقافة واحتياجات السفر. فريقنا هنا ليرشدك ويدعمك في كل خطوة.
                </p>
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
                        line-height: 1.3; /* ↓ tighter line spacing */
                        direction: ltr;
                        text-align: left;
                    }
                    h1 { font-size: 16px; font-weight: 700; margin-bottom: 6px; text-align: left; }
                    h2 { font-size: 15px; font-weight: 600; margin-top: 10px; margin-bottom: 6px; text-align: left; }
                    h3 { font-size: 14px; font-weight: 600; margin-top: 12px; margin-bottom: 5px; text-align: left; }
                    p { margin-bottom: 8px; text-align: left; }
                    ul { padding-left: 16px; margin-bottom: 8px; }
                    li { margin-bottom: 4px; }
                    strong { font-weight: 600; font-size: 13px; }
                    em { font-style: italic; color: #666666; }
                </style>
            </head>
            <body>
                <h1>Welcome to SyriaBooking</h1>
                <h2>Hotel Booking System</h2>

                <p><strong>Your Trusted Partner for Hotel Bookings Across Syria</strong></p>

                <p>
                    At SyriaBooking.sy, we are redefining travel and hospitality within Syria by offering a convenient,
                    transparent, and secure hotel booking experience for both local and international travelers. Founded
                    with a vision to support Syria’s growing tourism and business sectors, our platform connects travelers
                    with a wide range of hotels, guesthouses, and resorts — from affordable stays to luxury experiences —
                    all across the country.
                </p>

                <h3>1. Wide Selection of Properties</h3>
                <p>
                    Whether you're visiting Damascus, Aleppo, Latakia, Tartus, Homs, or any other Syrian city, we’ve
                    partnered with trusted hotels to give you comfortable, verified options.
                </p>

                <h3>2. Book Now, Pay on Arrival</h3>
                <p>
                    No need for credit cards or upfront payments. Simply search, choose, and book your stay — and pay
                    directly at the hotel when you arrive.
                </p>

                <h3>3. Easy Booking Process</h3>
                <p>
                    Designed for simplicity. Search hotels by city, dates, or budget, and complete your reservation in just a few clicks.
                </p>

                <h3>4. Real Information, No Surprises</h3>
                <p>
                    We provide detailed hotel descriptions, real photos, amenities, guest reviews, and location maps — so you always know what to expect.
                </p>

                <h3>5. Local Expertise</h3>
                <p>
                    We are a Syrian-based platform that understands the local market, the culture, and your travel needs.
                    Our team is here to guide and support you every step of the way.
                </p>
            </body>
            </html>
            """
        }

        webView.loadHTMLString(htmlString, baseURL: nil)
    }

}
