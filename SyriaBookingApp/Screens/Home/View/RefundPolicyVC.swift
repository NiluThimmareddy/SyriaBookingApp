//
//  RefundPolicyVC.swift
//  SyriaBookingApp
//
//  Created by ToqSoft on 24/10/25.
//

import UIKit

class RefundPolicyVC: UIViewController {
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var refundPolicyTypeLabel: UILabel!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var refundLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    
    var roomType: String?
    var roomBedType: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        updateTexts()
    }
    
    @objc func updateTexts() {
        let lang = AppSettings.shared.selectedLanguage
        
        let buttonFont = UIFont.systemFont(ofSize: 15, weight: .semibold)
        
        if lang == .arabic {
            refundLabel.text = "لا استرداد"
            
            if let roomType = roomType, let bedType = roomBedType {
                refundPolicyTypeLabel.text = "سياسة الاسترجاع - \(roomType) (\(bedType))"
            } else {
                refundPolicyTypeLabel.text = "سياسة الاسترجاع"
            }
            
            let closeAttributedTitle = NSAttributedString(
                string: "غلاق",
                attributes: [
                    .font: buttonFont,
                    .foregroundColor: closeButton.titleColor(for: .normal) ?? .white
                ]
            )
            closeButton.setAttributedTitle(closeAttributedTitle, for: .normal)
            
        } else {
            refundLabel.text = "No Refund"
            
            if let roomType = roomType, let bedType = roomBedType {
                refundPolicyTypeLabel.text = "Refund Policy - \(roomType) (\(bedType))"
            } else {
                refundPolicyTypeLabel.text = "Refund Policy"
            }
            
            let closeAttributedTitle = NSAttributedString(
                string: "Close",
                attributes: [
                    .font: buttonFont,
                    .foregroundColor: closeButton.titleColor(for: .normal) ?? .white
                ]
            )
            closeButton.setAttributedTitle(closeAttributedTitle, for: .normal)
        }
    }

    @IBAction func dismissButtonAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func closeButtonAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
