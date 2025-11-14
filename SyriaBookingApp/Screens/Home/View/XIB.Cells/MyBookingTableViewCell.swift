//
//  MyBookingTableViewCell.swift
//  SyriaBookingApp
//
//  Created by ToqSoft on 02/08/25.
//

/*
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
        let checkInDateStr = booking.checkInUtc.toDayMonthYear()
        let checkOutDateStr = booking.checkOutUtc.toDayMonthYear()
        datesLabel.text = "\(checkInDateStr) - \(checkOutDateStr)"
        
        let totalNights = calculateTotalNights(checkIn: checkInDateStr, checkOut: checkOutDateStr)
        let perNightRate = booking.totalAmount // assuming `totalAmount` stores per-night price
        let finalTotal = perNightRate
        totalAmountLabel.text = String(format: "Total: %.2f", finalTotal)
        upcomingDataLabel.text = booking.lastUpdatedUtc.toDayMonth()
        
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
    
    func calculateTotalNights(checkIn: String, checkOut: String) -> Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        
        guard let checkInDate = formatter.date(from: checkIn),
              let checkOutDate = formatter.date(from: checkOut) else {
            return 0
        }
        
        let components = Calendar.current.dateComponents([.day], from: checkInDate, to: checkOutDate)
        return max(components.day ?? 0, 0)
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
*/

import UIKit
import SkeletonView

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
        
        // Setup skeleton
        setupSkeleton()
    }
    
    private func setupSkeleton() {
        // Make the main container skeletonable
        backView.isSkeletonable = true
        contentView.isSkeletonable = true
        
        // Make all subviews skeletonable
        imgView.isSkeletonable = true
        hotelNameLabel.isSkeletonable = true
        roomTypeLabel.isSkeletonable = true
        datesLabel.isSkeletonable = true
        statusLabel.isSkeletonable = true
        upcomingDataLabel.isSkeletonable = true
        totalAmountLabel.isSkeletonable = true
        detailsButton.isSkeletonable = true
        cancelButton.isSkeletonable = true
        contactSupportButton.isSkeletonable = true
        
        // Configure skeleton for labels
        hotelNameLabel.linesCornerRadius = 4
        roomTypeLabel.linesCornerRadius = 4
        datesLabel.linesCornerRadius = 4
        statusLabel.linesCornerRadius = 4
        upcomingDataLabel.linesCornerRadius = 4
        totalAmountLabel.linesCornerRadius = 4
        
        // Configure skeleton for buttons
        detailsButton.skeletonCornerRadius = 8
        cancelButton.skeletonCornerRadius = 8
        contactSupportButton.skeletonCornerRadius = 8
        
        // Configure skeleton for image view
        imgView.skeletonCornerRadius = 8
    }
    
    func showSkeleton() {
        // Hide actual content and show placeholder
        hotelNameLabel.text = "Loading Hotel Name..."
        roomTypeLabel.text = "Loading Room Type..."
        datesLabel.text = "Loading dates..."
        statusLabel.text = "Loading"
        upcomingDataLabel.text = "Loading..."
        totalAmountLabel.text = "Loading total..."
        
        // Hide buttons during skeleton
        detailsButton.isHidden = true
        cancelButton.isHidden = true
        contactSupportButton.isHidden = true
        
        // Show skeleton
        backView.showAnimatedGradientSkeleton()
        imgView.showAnimatedGradientSkeleton()
        hotelNameLabel.showAnimatedGradientSkeleton()
        roomTypeLabel.showAnimatedGradientSkeleton()
        datesLabel.showAnimatedGradientSkeleton()
        statusLabel.showAnimatedGradientSkeleton()
        upcomingDataLabel.showAnimatedGradientSkeleton()
        totalAmountLabel.showAnimatedGradientSkeleton()
    }
    
    func hideSkeleton() {
        // Hide skeleton
        backView.hideSkeleton()
        imgView.hideSkeleton()
        hotelNameLabel.hideSkeleton()
        roomTypeLabel.hideSkeleton()
        datesLabel.hideSkeleton()
        statusLabel.hideSkeleton()
        upcomingDataLabel.hideSkeleton()
        totalAmountLabel.hideSkeleton()
        
        // Show buttons after skeleton is hidden
        detailsButton.isHidden = false
        contactSupportButton.isHidden = false
    }
    
    func configure(booking: BookingHistoryModel) {
        // Hide skeleton first
        hideSkeleton()
        
        currentBooking = booking
        hotelNameLabel.text = booking.hotelName
        roomTypeLabel.text = booking.roomType
        let checkInDateStr = booking.checkInUtc.toDayMonthYear()
        let checkOutDateStr = booking.checkOutUtc.toDayMonthYear()
        datesLabel.text = "\(checkInDateStr) - \(checkOutDateStr)"
        
        let totalNights = calculateTotalNights(checkIn: checkInDateStr, checkOut: checkOutDateStr)
        let perNightRate = booking.totalAmount // assuming `totalAmount` stores per-night price
        let finalTotal = perNightRate
        totalAmountLabel.text = String(format: "Total: %.2f", finalTotal)
        upcomingDataLabel.text = booking.lastUpdatedUtc.toDayMonth()
        
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
    
    func calculateTotalNights(checkIn: String, checkOut: String) -> Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        
        guard let checkInDate = formatter.date(from: checkIn),
              let checkOutDate = formatter.date(from: checkOut) else {
            return 0
        }
        
        let components = Calendar.current.dateComponents([.day], from: checkInDate, to: checkOutDate)
        return max(components.day ?? 0, 0)
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // Reset cell state when reused
        hideSkeleton()
        currentBooking = nil
    }
}
