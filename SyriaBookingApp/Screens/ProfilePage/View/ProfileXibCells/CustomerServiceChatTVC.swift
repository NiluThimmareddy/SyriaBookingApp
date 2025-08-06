//
//  CustomerServiceTVC.swift
//  HotelBooking
//
//  Created by praveenkumar on 02/07/25.
//

import UIKit

class CustomerServiceChatTVC: UITableViewCell {
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var bubbleView: UIView!
    @IBOutlet weak var bubbleLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var bubbleTrailingConstraint: NSLayoutConstraint!
    override func awakeFromNib() {
            super.awakeFromNib()
            bubbleView.layer.cornerRadius = 12
            bubbleView.clipsToBounds = true
        }

    func configure(with message: ChatMessage) {
        messageLabel.text = message.message
        messageLabel.textAlignment = .left
        
        if message.isFromAgent {
           
            bubbleLeadingConstraint.constant = 10
            bubbleTrailingConstraint.constant = 100
            bubbleView.backgroundColor = UIColor.systemGray5
            messageLabel.textColor = .black
        } else {
            
            bubbleLeadingConstraint.constant = 100
            bubbleTrailingConstraint.constant = 10
            bubbleView.backgroundColor = UIColor.systemBlue
            messageLabel.textColor = .white
        }
        
        layoutIfNeeded()
    }

    }
