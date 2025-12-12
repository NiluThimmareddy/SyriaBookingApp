//
//  EmailIDView.swift
//  SyriaBookingApp
//
//  Created by toqsoft on 10/12/25.
//


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
