//
//  ArchiveTableViewCell.swift
//  SyriaBookingApp
//
//  Created by toqsoft on 11/09/25.
//

import UIKit

class ArchiveTableViewCell : UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var hotelIdLabel: UILabel!
    @IBOutlet weak var datesLabel: UILabel!
    @IBOutlet weak var pendingLabel: UILabel!
    @IBOutlet weak var featureDateLabel: UILabel!
    @IBOutlet weak var totalAmountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backView.applyCardStyle()
        pendingLabel.layer.cornerRadius = 6
        pendingLabel.clipsToBounds = true
    }
    
    
    func configure(booking: BookingHistoryModel) {
       
        hotelIdLabel.text = "\(booking.id ) ᐧ \(booking.roomId)"
        datesLabel.text = "\(booking.checkInUtc.toDayMonthYear()) - \(booking.checkOutUtc.toDayMonthYear())"
        totalAmountLabel.text = "₹\(booking.totalAmount)"
        featureDateLabel.text = booking.lastUpdatedUtc.toDayMonth()
        
        switch booking.status.lowercased() {
        case "pending":
            imgView.image = UIImage(systemName: "clock")
            pendingLabel.text = "Pending"
            pendingLabel.backgroundColor = .systemBlue    
        case "cancelled":
            imgView.image = UIImage(systemName: "xmark.circle")
            pendingLabel.text = "Cancelled"
            pendingLabel.backgroundColor = .systemRed
        case "completed":
            imgView.image = UIImage(systemName: "checkmark.circle")
            pendingLabel.text = "Completed"
            pendingLabel.backgroundColor = .systemGreen
        default:
            imgView.image = UIImage(systemName: "house")
            pendingLabel.text = booking.status
            pendingLabel.backgroundColor = .darkGray
            
        }
    }
    
}
