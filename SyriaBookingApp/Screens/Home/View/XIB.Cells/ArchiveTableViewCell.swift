//
//  ArchiveTableViewCell.swift
//  SyriaBookingApp
//
//  Created by toqsoft on 11/09/25.
//

import UIKit
import SkeletonView

class ArchiveTableViewCell: UITableViewCell {

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
        
        // Setup skeleton
        setupSkeleton()
    }
    
    private func setupSkeleton() {
        // Make the main container skeletonable
        backView.isSkeletonable = true
        contentView.isSkeletonable = true
        
        // Make all subviews skeletonable
        imgView.isSkeletonable = true
        hotelIdLabel.isSkeletonable = true
        datesLabel.isSkeletonable = true
        pendingLabel.isSkeletonable = true
        featureDateLabel.isSkeletonable = true
        totalAmountLabel.isSkeletonable = true
        
        // Configure skeleton for labels
        hotelIdLabel.linesCornerRadius = 4
        datesLabel.linesCornerRadius = 4
        pendingLabel.linesCornerRadius = 4
        featureDateLabel.linesCornerRadius = 4
        totalAmountLabel.linesCornerRadius = 4
        
        // Configure skeleton for image view
        imgView.skeletonCornerRadius = 8
    }
    
    func showSkeleton() {
        // Hide actual content
        hotelIdLabel.text = "Loading..."
        datesLabel.text = "Loading..."
        pendingLabel.text = "Loading"
        featureDateLabel.text = "Loading"
        totalAmountLabel.text = "Loading..."
        
        // Show skeleton
        backView.showAnimatedGradientSkeleton()
        imgView.showAnimatedGradientSkeleton()
        hotelIdLabel.showAnimatedGradientSkeleton()
        datesLabel.showAnimatedGradientSkeleton()
        pendingLabel.showAnimatedGradientSkeleton()
        featureDateLabel.showAnimatedGradientSkeleton()
        totalAmountLabel.showAnimatedGradientSkeleton()
    }
    
    func hideSkeleton() {
        // Hide skeleton
        backView.hideSkeleton()
        imgView.hideSkeleton()
        hotelIdLabel.hideSkeleton()
        datesLabel.hideSkeleton()
        pendingLabel.hideSkeleton()
        featureDateLabel.hideSkeleton()
        totalAmountLabel.hideSkeleton()
    }
    
    func configure(booking: BookingHistoryModel) {
        // Hide skeleton first
        hideSkeleton()
        
        // Set actual data
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

    override func prepareForReuse() {
        super.prepareForReuse()
        // Reset cell state when reused
        hideSkeleton()
    }
}
