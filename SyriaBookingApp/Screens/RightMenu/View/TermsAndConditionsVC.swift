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

            <!-- You can continue adding the rest of the HTML content from your post here -->

            <h6>Thank you for visiting!</h6>
            <p>By using our website or services, you consent to the terms of this Privacy Policy. Please review this policy periodically for updates or changes.</p>

            <p><strong>Contact:</strong> <a href="mailto:info@syriabooking.sy">info@syriabooking.sy</a></p>
        </body>
        </html>
        """

        webView.loadHTMLString(htmlString, baseURL: nil)
    }

}
