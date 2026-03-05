//
//  SocialMediaView.swift
//  SyriaBookingApp
//
//  Created by toqsoft on 09/12/25.
//

import UIKit

class SocialMediaView: UIView {

    @IBOutlet weak var followLabel: UILabel!
    @IBOutlet weak var faceBookButton: UIButton!
    @IBOutlet weak var instagramButton: UIButton!
    @IBOutlet weak var linkedinButton: UIButton!
    @IBOutlet weak var tiktokButton: UIButton!
    @IBOutlet weak var syriabookingIncLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        updateTexts()
    }
    
    @objc func updateTexts() {
        let lang = AppSettings.shared.selectedLanguage
        
        if lang == .english {
            // English texts
            followLabel.text = "Follow us:"
            syriabookingIncLabel.text = "© 2025-26 SyriaBooking Inc. All rights reserved."
        } else {
            // Arabic texts
            followLabel.text = "تابعنا:"
            syriabookingIncLabel.text = "© 2025-26 سيريا بوكينغ. جميع الحقوق محفوظة."
        }
    }

    @IBAction func facebookButtonAction(_ sender: Any) {
        openSocialApp(
            appURL: "fb://",
            webURL: "https://www.facebook.com/SyriaBooking.sy/"
        )
    }

    @IBAction func instagramButtonAction(_ sender: Any) {
        openSocialApp(
            appURL: "instagram://",
            webURL: "https://www.instagram.com/syria_booking/"
        )
    }

    @IBAction func linkedinButtonAction(_ sender: Any) {
        openSocialApp(
            appURL: "linkedin://",
            webURL: "https://www.linkedin.com/company/syriabooking"
        )
    }

    @IBAction func tiktokButtonAction(_ sender: Any) {
        openSocialApp(
            appURL: "tiktok://",
            webURL: "https://www.tiktok.com/@syriabooking"
        )
    }

    private func openSocialApp(appURL: String, webURL: String) {
        if let appURL = URL(string: appURL),
           UIApplication.shared.canOpenURL(appURL) {
            UIApplication.shared.open(appURL)
        } else if let webURL = URL(string: webURL) {
            UIApplication.shared.open(webURL)
        }
    }
}
