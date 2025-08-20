

import UIKit
import WebKit

class AboutUsVC: UIViewController {

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!

    private var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebView()
        loadHTMLContent()
        topView.addBottomShadow()
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

              h1 {
                  font-size: 18px;
                  font-weight: 600;
                  color: #000000;
                  margin-top: 0;
                  margin-bottom: 8px;
              }

              h2 {
                  font-size: 19px;
                  color: #000000;
                  margin-top: 0;
                  margin-bottom: 8px;
              }

              h3 {
                  font-size: 18px;
                  font-weight: 600;
                  color: #000000;
                  margin-top: 24px;
                  margin-bottom: 8px;
              }

              h5, h6 {
                  font-size: 18px;
                  font-weight: 600;
                  color: #000000;
                  margin-top: 24px;
                  margin-bottom: 8px;
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

        webView.loadHTMLString(htmlString, baseURL: nil)
    }
}

