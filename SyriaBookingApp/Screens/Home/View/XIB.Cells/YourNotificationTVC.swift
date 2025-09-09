//
//  YourNotificationTVC.swift
//  HotelBooking
//
//  Created by praveenkumar on 09/07/25.
//

import UIKit

class YourNotificationTVC: UITableViewCell {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var hotelNameLabel: UILabel!
    @IBOutlet weak var datesLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var upComingDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(with booking: Booking) {
        hotelNameLabel.text = booking.hotelName
        datesLabel.text = "\(booking.checkIn) - \(booking.checkOut)"
        statusLabel.text = booking.status.capitalized
//        upComingDateLabel.text = "Check-in: \(booking.checkIn)"
        
        switch booking.status.lowercased() {
        case "pending":
            imgView.image = UIImage(systemName: "clock")
            statusLabel.text = "Pending"
            statusLabel.textColor = .systemBlue
            imgView.tintColor = .systemBlue
        case "cancelled":
            imgView.image = UIImage(systemName: "xmark.circle")
            statusLabel.text = "Cancelled"
            statusLabel.textColor = .systemRed
            imgView.tintColor = .systemRed
        case "completed":
            imgView.image = UIImage(systemName: "checkmark.circle")
            statusLabel.text = "Completed"
            statusLabel.textColor = .systemGreen
            imgView.tintColor = .systemGreen
        default:
            imgView.image = UIImage(systemName: "house")
            statusLabel.text = booking.status
            statusLabel.textColor = .systemGray
            imgView.tintColor = .systemGray
        }
    }
}
