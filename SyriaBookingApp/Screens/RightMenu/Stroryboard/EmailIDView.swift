//
//  EmailIDView.swift
//  SyriaBookingApp
//
//  Created by toqsoft on 10/12/25.
//

/*
import UIKit
import MessageUI

class EmailIDView: UIView, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var personImageview: UIImageView!
    @IBOutlet weak var stillHaveQuestionsLabel: UILabel!
    @IBOutlet weak var emailUsButton: UIButton!

    @IBAction func emailUsButtonAction(_ sender: Any) {
        if MFMailComposeViewController.canSendMail() {
            let mailVC = MFMailComposeViewController()
            mailVC.mailComposeDelegate = self
            mailVC.setToRecipients(["info@syriabooking.sy"])
            mailVC.setSubject("Support Inquiry")
            mailVC.setMessageBody(
                """
                Hello SyriaBooking Team,

                I have a question regarding your application.

                Regards,
                """,
                isHTML: false
            )

            if let topVC = UIApplication.shared.topViewController() {
                topVC.present(mailVC, animated: true)
            }

        } else {
            let email = "info@syriabooking.sy"
            if let url = URL(string: "mailto:\(email)") {
                UIApplication.shared.open(url, options: [:])
            }
        }
    }

    func mailComposeController(
        _ controller: MFMailComposeViewController,
        didFinishWith result: MFMailComposeResult,
        error: Error?
    ) {
        controller.dismiss(animated: true)
    }
}
*/

import UIKit
import MessageUI

class EmailIDView: UIView, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var personImageview: UIImageView!
    @IBOutlet weak var stillHaveQuestionsLabel: UILabel!
    @IBOutlet weak var emailUsButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        updateTexts()
    }
    
    @objc func updateTexts() {
        let lang = AppSettings.shared.selectedLanguage
        
        let buttonFont = UIFont.systemFont(ofSize: 14, weight: .regular)
        
        if lang == .english {
            stillHaveQuestionsLabel.text = "Still have questions?"
            let buttonTitle = "Mail us info@syriabooking.sy"
            let attributedTitle = NSAttributedString(
                string: buttonTitle,
                attributes: [
                    .font: buttonFont,
                    .foregroundColor: emailUsButton.titleColor(for: .normal) ?? .systemBlue
                ]
            )
            emailUsButton.setAttributedTitle(attributedTitle, for: .normal)
            
        } else {
            stillHaveQuestionsLabel.text = "لا تزال لديك أسئلة؟"
            let buttonTitle = "راسلنا info@syriabooking.sy"
            let attributedTitle = NSAttributedString(
                string: buttonTitle,
                attributes: [
                    .font: buttonFont,
                    .foregroundColor: emailUsButton.titleColor(for: .normal) ?? .systemBlue
                ]
            )
            emailUsButton.setAttributedTitle(attributedTitle, for: .normal)
        }
    }

    @IBAction func emailUsButtonAction(_ sender: Any) {
        if MFMailComposeViewController.canSendMail() {
            let mailVC = MFMailComposeViewController()
            mailVC.mailComposeDelegate = self
            
            let lang = AppSettings.shared.selectedLanguage
            
            mailVC.setToRecipients(["info@syriabooking.sy"])
            
            if lang == .english {
                mailVC.setSubject("Support Inquiry")
            } else {
                mailVC.setSubject("استفسار دعم")
            }
            
            if lang == .english {
                mailVC.setMessageBody(
                    """
                    Hello SyriaBooking Team,

                    I have a question regarding your application.

                    Regards,
                    """,
                    isHTML: false
                )
            } else {
                mailVC.setMessageBody(
                    """
                    مرحبا فريق سيريا بوكينغ،

                    لدي استفسار بخصوص تطبيقكم.

                    مع التحية،
                    """,
                    isHTML: false
                )
            }

            if let topVC = UIApplication.shared.topViewController() {
                topVC.present(mailVC, animated: true)
            }

        } else {
            let email = "info@syriabooking.sy"
            if let url = URL(string: "mailto:\(email)") {
                UIApplication.shared.open(url, options: [:])
            }
        }
    }

    func mailComposeController(
        _ controller: MFMailComposeViewController,
        didFinishWith result: MFMailComposeResult,
        error: Error?
    ) {
        controller.dismiss(animated: true)
    }
}
