//
//  MyBookingTableViewCell.swift
//  SyriaBookingApp
//
//  Created by ToqSoft on 02/08/25.
//

import UIKit

protocol MyBookingCellDelegate: AnyObject {
    func didTapDetails(for booking: BookingHistoryModel)
    func didTapCancel(for booking: BookingHistoryModel)
}

class MyBookingTableViewCell: UITableViewCell {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var hotelNameLabel: UILabel!
    @IBOutlet weak var roomTypeLabel: UILabel!
    @IBOutlet weak var datesLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var upcomingDataLabel: UILabel!
    @IBOutlet weak var totalAmountLabel: UILabel!
    @IBOutlet weak var detailsButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var contactSupportButton: UIButton!
    
    weak var delegate: MyBookingCellDelegate?
    var currentBooking: BookingHistoryModel?
    var contactSupprtButtonAction : ((BookingHistoryModel)->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backView.applyCardStyle()
        statusLabel.layer.cornerRadius = 6
        statusLabel.clipsToBounds = true
    }
    
    func configure(booking: BookingHistoryModel) {
        currentBooking = booking
        hotelNameLabel.text = booking.hotelName
        roomTypeLabel.text = booking.roomType
        datesLabel.text = "\(booking.checkInUtc) - \(booking.checkOutUtc)"
        totalAmountLabel.text = "₹\(booking.totalAmount)"
        
        switch booking.status.lowercased() {
        case "pending":
            imgView.image = UIImage(systemName: "clock")
            statusLabel.text = "Pending"
            statusLabel.backgroundColor = .systemBlue
            cancelButton.isHidden = false
            
        case "cancelled":
            imgView.image = UIImage(systemName: "xmark.circle")
            statusLabel.text = "Cancelled"
            statusLabel.backgroundColor = .systemRed
            cancelButton.isHidden = true
            
        case "completed":
            imgView.image = UIImage(systemName: "checkmark.circle")
            statusLabel.text = "Completed"
            statusLabel.backgroundColor = .systemGreen
            cancelButton.isHidden = true
            
        default:
            imgView.image = UIImage(systemName: "house")
            statusLabel.text = booking.status
            statusLabel.backgroundColor = .darkGray
            cancelButton.isHidden = true
        }
    }

    @IBAction func detailsButtonAction(_ sender: Any) {
        if let booking = currentBooking {
            delegate?.didTapDetails(for: booking)
        }
    }
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        if let booking = currentBooking {
            delegate?.didTapCancel(for: booking)
        }
    }
    
    @IBAction func contactSupportButtonAction(_ sender: Any) {
        if let booking = currentBooking {
            self.contactSupprtButtonAction?(booking)
        }
      
    }
}
