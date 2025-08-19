
import UIKit
import WebKit

class PrivacyPolicyViewController: UIViewController {

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    
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
        topView.addBottomShadow()
    }
    
    private func loadHTMLContent() {
        let htmlString = """
        <html>
        <head>
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
           <style>
               body {
                   font-family: -apple-system;
                   padding: 20px;
                   color: #333333;
                   font-size: 16px;
                   line-height: 1.6;
               }

               h5, h6 {
                   font-size: 18px;
                   font-weight: 600;
                   color: #000000;
                   margin-top: 24px;
                   margin-bottom: 8px;
               }

               h2 {
                   font-size: 24px;
                   color: #000000;
               }

               ul {
                   padding-left: 20px;
               }

               li {
                   margin-bottom: 8px;
               }

               a {
                   color: #007BFF;
                   text-decoration: none;
                   font-weight: 500;
               }

               strong {
                   font-weight: 600;
                   font-size: 17px;
               }

               em {
                   font-style: italic;
                   color: #666666;
               }
           </style>
        </head>
        <body>
            <p><em>Last update: Mar 17, 2025</em></p>

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
            <strong>Phone:</strong> +963-123-456789</p>

            <h6>Thank you for visiting!</h6>
            <p>By using our website or services, you consent to the terms of this Privacy Policy. Please review this policy periodically for updates or changes.</p>
        </body>
        </html>
        """

        webView.loadHTMLString(htmlString, baseURL: nil)
    }

}
