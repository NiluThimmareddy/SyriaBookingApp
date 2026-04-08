//
//  MyReviewsTVC.swift
//  SyriaBookingApp
//
//  Created by Hitman on 07/04/26.
//

import UIKit

class MyReviewsTVC: UITableViewCell {
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var hotelImageView: UIImageView!
    @IBOutlet weak var hotelNameLabel: UILabel!
    @IBOutlet weak var reviewedDateLabel: UILabel!
    @IBOutlet weak var ratingsView: CosmosView!
    @IBOutlet weak var reviewDescriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.isSkeletonable = true
        self.contentView.isSkeletonable = true
        setupStarSize()
    }
    
    func setupStarSize() {
        if UIDevice.current.userInterfaceIdiom == .pad {
            ratingsView.settings.starSize = 22
        } else {
            ratingsView.settings.starSize = 14
        }
    }
    
    func configure(with review: Review) {
        hotelImageView.image = UIImage(named: "HotelPlaceholder")
        reviewedDateLabel.text = formattedDate(from: review.createdOn)
        ratingsView.rating = Double(review.rating)
        reviewDescriptionLabel.text = review.reviewText
    }
    
    private func formattedDate(from isoString: String) -> String {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        let displayFormatter = DateFormatter()
        displayFormatter.dateStyle = .short
        displayFormatter.timeStyle = .medium
        
        if let date = isoFormatter.date(from: isoString) {
            return displayFormatter.string(from: date)
        } else {
            return isoString
        }
    }
}
