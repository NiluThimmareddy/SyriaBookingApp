//
//  SafetyResourceCenterVC.swift
//  SyriaBookingApp
//
//  Created by toqsoft on 20/08/25.
//

import UIKit
import WebKit

class SafetyResourceCenterVC : UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var bottomView: UIView!
    
    private var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebView()
        loadHTMLContent()
        scrollView.addTopShadow()
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
                    font-size: 20px;
                    font-weight: 700;
                    color: #000000;
                    margin-top: 0;
                    margin-bottom: 12px;
                }

                h3 {
                    font-size: 18px;
                    font-weight: 600;
                    color: #000000;
                    margin-top: 24px;
                    margin-bottom: 8px;
                }

                p {
                    margin-bottom: 16px;
                }

                ul {
                    padding-left: 20px;
                }

                li {
                    margin-bottom: 8px;
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
            <h1>Your Safety Is Our Priority</h1>

            <p><strong>At SyriaBooking.sy</strong>, your peace of mind is at the heart of everything we do. We are committed to providing a safe, secure, and informed travel experience — from the moment you book until you check out.</p>

            <p>This Safety Resource Center offers essential guidance and support to help you travel confidently across Syria.</p>

            <h3>1. Booking Safety & Privacy</h3>
            <ul>
                <li><strong>Verified Hotels Only:</strong> All listed properties on our platform go through a strict verification process before being published.</li>
                <li><strong>Secure Platform:</strong> Your data is protected using industry-standard encryption and privacy protocols.</li>
                <li><strong>No Advance Payment Required:</strong> With our “Pay on Arrival” system, you don’t need to enter any payment details online.</li>
            </ul>

            <h3>2. Hotel Safety Measures</h3>
            <p>We encourage our hotel partners to adopt and maintain the following safety practices:</p>
            <ul>
                <li>Daily room cleaning and sanitization</li>
                <li>On-site availability of first aid kits</li>
                <li>Emergency contact information readily available</li>
                <li>Trained staff for guest safety and emergency response</li>
                <li>Health & hygiene protocols especially for high-contact areas</li>
            </ul>
            <p>Look for the <em>“Safety Certified”</em> badge on hotels that go the extra mile.</p>

            <h3>3. Traveler Responsibility</h3>
            <p>To ensure a safe experience for everyone:</p>
            <ul>
                <li>Follow local health, safety, and travel guidelines</li>
                <li>Respect hotel rules and staff instructions</li>
                <li>Carry proper ID and travel documents</li>
                <li>Keep emergency numbers accessible</li>
            </ul>

            <h3>4. In Case of Emergency</h3>
            <p>In any emergency, you can contact:</p>
            <ul>
                <li><strong>Local Police:</strong> 112</li>
                <li><strong>Medical Emergency:</strong> 110</li>
                <li><strong>Email:</strong> info@syriabooking.sy</li>
                <li><strong>Phone:</strong> +963-123-456789</li>
            </ul>

            <h3>5. Travel Tips for Syria</h3>
            <ul>
                <li>Stick to well-known destinations and hotel areas</li>
                <li>Avoid traveling late at night in unfamiliar locations</li>
                <li>Keep valuables secure and avoid displaying large amounts of cash</li>
                <li>Use hotel safes whenever possible</li>
                <li>Share your travel itinerary with family or friends</li>
            </ul>

            <h3>Need Help?</h3>
            <p>If you have any concerns before, during, or after your stay, our customer care team is here to support you.</p>
            <p><strong>We’re available 24/7</strong> to ensure your safety and satisfaction.</p>
        </body>
        </html>
        """

        webView.loadHTMLString(htmlString, baseURL: nil)
    }

}

