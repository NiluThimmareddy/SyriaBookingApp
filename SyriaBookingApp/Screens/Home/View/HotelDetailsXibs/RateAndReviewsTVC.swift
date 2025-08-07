//
//  RateAndReviewsTVC.swift
//  SyriaBookingApp
//
//  Created by toqsoft on 07/08/25.
//

import UIKit

class RateAndReviewsTVC : UITableViewCell {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var personImageView: UIImageView!
    @IBOutlet weak var reviewerNameLabel: UILabel!
    @IBOutlet weak var reviewDateLabel: UILabel!
    @IBOutlet weak var starRatings: CosmosView!
    @IBOutlet weak var reviewTextLabel: UILabel!
     
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    func configure(with review: Review) {
        reviewerNameLabel.text = review.reviewerName
        reviewDateLabel.text = formattedDate(from: review.createdOn)
        starRatings.rating = Double(review.rating)
        reviewTextLabel.text = review.reviewText
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
