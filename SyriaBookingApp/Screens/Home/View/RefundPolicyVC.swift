//
//  RefundPolicyVC.swift
//  SyriaBookingApp
//  Created by ToqSoft on 24/10/25.

import UIKit

class RefundPolicyVC: UIViewController {
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var refundPolicyTypeLabel: UILabel!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var refundTextView: UITextView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var refundTextViewHeightConstraint: NSLayoutConstraint!
    
    var roomType: String?
    var roomBedType: String?
    var refundPolicy: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        updateTexts()
    }
    
    @objc func updateTexts() {
        let lang = AppSettings.shared.selectedLanguage
        let buttonFont = UIFont.systemFont(ofSize: 15, weight: .semibold)
        
        let defaultText = (lang == .arabic) ? "لا استرداد" : "No Refund"
        refundTextView.text = refundPolicy ?? defaultText
        
        if lang == .arabic {
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
        
        DispatchQueue.main.async {
            self.updateTextViewHeight()
        }
    }
    
    func updateTextViewHeight() {
        let fixedWidth = refundTextView.frame.size.width
        
        let newSize = refundTextView.sizeThatFits(
            CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude)
        )
        let maxHeight: CGFloat = 500
        
        if newSize.height > maxHeight {
            refundTextViewHeightConstraint.constant = maxHeight
            refundTextView.isScrollEnabled = true
        } else {
            refundTextViewHeightConstraint.constant = newSize.height
            refundTextView.isScrollEnabled = false
        }        
        self.view.layoutIfNeeded()
    }

    @IBAction func dismissButtonAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func closeButtonAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
