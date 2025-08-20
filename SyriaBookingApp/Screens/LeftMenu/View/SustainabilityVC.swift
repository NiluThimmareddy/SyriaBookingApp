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
                    margin-bottom: 8px;
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

        webView.loadHTMLString(htmlString, baseURL: nil)
    }
}

