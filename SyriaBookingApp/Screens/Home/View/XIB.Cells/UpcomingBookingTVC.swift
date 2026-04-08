//
//  UpcomingBookingTVC.swift
//  SyriaBookingApp
//
//  Created by Hitman on 06/04/26.
//

import UIKit

protocol MyBookingCellDelegate: AnyObject {
    func didTapDetails(for booking: BookingHistoryModel)
    func didTapCancel(for booking: BookingHistoryModel)
}

class UpcomingBookingTVC: UITableViewCell {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var hotelImgView: UIImageView!
    @IBOutlet weak var hotelNameLabel: UILabel!
    @IBOutlet weak var roomTypeLabel: UILabel!
    @IBOutlet weak var statusImgView: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var checkInAndCheckOutDatesLabel: UILabel!
    @IBOutlet weak var bookedDateLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var detailsButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var contactSupportButton: UIButton!
    @IBOutlet weak var statusView: UIView!
    
    weak var delegate: MyBookingCellDelegate?
    var currentBooking: BookingHistoryModel?
    var contactSupprtButtonAction : ((BookingHistoryModel)->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backView.applyCardStyle()
        setupSkeleton()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        hideSkeleton()
        currentBooking = nil
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
    
    func configure(booking: BookingHistoryModel) {
        currentBooking = booking
        hotelNameLabel.text = booking.hotelName
        hotelImgView.image = UIImage(named: "HotelPlaceholder")
        let checkInDateStr = booking.checkInUtc.toDayMonthYear()
        let checkOutDateStr = booking.checkOutUtc.toDayMonthYear()
        checkInAndCheckOutDatesLabel.text = "\(checkInDateStr) - \(checkOutDateStr)"
        let totalNights = calculateTotalNights(checkIn: checkInDateStr, checkOut: checkOutDateStr)
        let perNightRate = booking.totalAmount // assuming `totalAmount` stores per-night price
        let finalTotal = perNightRate
        totalPriceLabel.text = String(format: "Total: %.2f", finalTotal)
        bookedDateLabel.text = "Booked on \(booking.lastUpdatedUtc.toDayMonth())"
        roomTypeLabel.text = "\(booking.roomType) • \(totalNights) Nights"
        switch booking.status.lowercased() {
        case "pending":
            statusImgView.image = UIImage(systemName: "clock")
            statusLabel.text = "Pending"
            statusView.backgroundColor = .systemBlue
            cancelButton.isHidden = false
            
        case "cancelled":
            statusImgView.image = UIImage(systemName: "xmark.circle")
            statusLabel.text = "Cancelled"
            statusView.backgroundColor = .systemRed
            cancelButton.isHidden = true
            
        case "completed":
            statusImgView.image = UIImage(systemName: "checkmark.circle")
            statusLabel.text = "Completed"
            statusView.backgroundColor = .systemGreen
            cancelButton.isHidden = true
            
        default:
            statusImgView.image = UIImage(systemName: "house")
            statusLabel.text = booking.status
            statusView.backgroundColor = .darkGray
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
    
    private func setupSkeleton() {
        // Make the main container skeletonable
        backView.isSkeletonable = true
        contentView.isSkeletonable = true
        
        // Make all subviews skeletonable
        statusImgView.isSkeletonable = true
        statusView.isSkeletonable = true
        hotelImgView.isSkeletonable = true
        hotelNameLabel.isSkeletonable = true
        roomTypeLabel.isSkeletonable = true
        checkInAndCheckOutDatesLabel.isSkeletonable = true
        statusLabel.isSkeletonable = true
        bookedDateLabel.isSkeletonable = true
        totalPriceLabel.isSkeletonable = true
        detailsButton.isSkeletonable = true
        cancelButton.isSkeletonable = true
        contactSupportButton.isSkeletonable = true
        
        // Configure skeleton for labels
        hotelNameLabel.linesCornerRadius = 4
        roomTypeLabel.linesCornerRadius = 4
        checkInAndCheckOutDatesLabel.linesCornerRadius = 4
        statusLabel.linesCornerRadius = 4
        bookedDateLabel.linesCornerRadius = 4
        totalPriceLabel.linesCornerRadius = 4
        
        // Configure skeleton for buttons
        detailsButton.skeletonCornerRadius = 8
        cancelButton.skeletonCornerRadius = 8
        contactSupportButton.skeletonCornerRadius = 8
        
        // Configure skeleton for image view
        hotelImgView.skeletonCornerRadius = 8
    }
    
    func showSkeleton() {
        // Hide actual content and show placeholder
        hotelNameLabel.text = "Loading Hotel Name..."
        roomTypeLabel.text = "Loading Room Type..."
        checkInAndCheckOutDatesLabel.text = "Loading dates..."
        statusLabel.text = "Loading"
        bookedDateLabel.text = "Loading..."
        totalPriceLabel.text = "Loading total..."
        
        // Hide buttons during skeleton
        detailsButton.isHidden = true
        cancelButton.isHidden = true
        contactSupportButton.isHidden = true
        
        // Show skeleton
        backView.showAnimatedGradientSkeleton()
        hotelImgView.showAnimatedGradientSkeleton()
        hotelNameLabel.showAnimatedGradientSkeleton()
        roomTypeLabel.showAnimatedGradientSkeleton()
        checkInAndCheckOutDatesLabel.showAnimatedGradientSkeleton()
        statusLabel.showAnimatedGradientSkeleton()
        bookedDateLabel.showAnimatedGradientSkeleton()
        totalPriceLabel.showAnimatedGradientSkeleton()
        statusImgView.showAnimatedGradientSkeleton()
        statusView.showAnimatedGradientSkeleton()
    }
    
    func hideSkeleton() {
        // Hide skeleton
        backView.hideSkeleton()
        hotelImgView.hideSkeleton()
        hotelNameLabel.hideSkeleton()
        roomTypeLabel.hideSkeleton()
        checkInAndCheckOutDatesLabel.hideSkeleton()
        statusLabel.hideSkeleton()
        bookedDateLabel.hideSkeleton()
        totalPriceLabel.hideSkeleton()
        statusImgView.hideSkeleton()
        statusView.hideSkeleton()
        // Show buttons after skeleton is hidden
        detailsButton.isHidden = false
        contactSupportButton.isHidden = false
    }
}
