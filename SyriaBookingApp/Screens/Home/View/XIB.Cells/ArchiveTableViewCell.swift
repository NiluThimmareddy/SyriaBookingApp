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
        hotelIdLabel.text = "\(booking.hotelName) ᐧ \(booking.roomType)"
        datesLabel.text = "\(booking.checkInUtc.toDayMonthYear()) - \(booking.checkOutUtc.toDayMonthYear())"
        featureDateLabel.text = booking.lastUpdatedUtc.toDayMonth()
        
        // Calculate total nights between check-in and check-out
        if let checkInDate = booking.checkInUtc.toDate(),
           let checkOutDate = booking.checkOutUtc.toDate() {
            let nights = Calendar.current.dateComponents([.day], from: checkInDate, to: checkOutDate).day ?? 0
            let totalPrice = (Double(booking.totalAmount) ?? 0.0) * Double(nights)
            totalAmountLabel.text = "Total: \(String(format: "%.2f", totalPrice))"
        } else {
            totalAmountLabel.text = "Total: \(booking.totalAmount)"
        }

        // Set status style
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
