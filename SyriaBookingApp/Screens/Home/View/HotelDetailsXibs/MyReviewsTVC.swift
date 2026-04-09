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
    
    func configure(with review: Review, comingFromProfile:Bool) {
  
        if comingFromProfile{
            let data = getHotelImage(for: review)
            hotelNameLabel.text = data.1
            if let url = data.0 {
                hotelImageView.loadImage(from: url)
            }else{
                hotelImageView.image = UIImage(named: "HotelPlaceholder")
            }
        }else {
            hotelNameLabel.text = review.reviewerName
            
            if let firstChar = review.reviewerName.first,
               firstChar.isLetter {
                
                let letter = String(firstChar).lowercased()
                let imageName = "\(letter).circle.fill"
                
                let image = UIImage(systemName: imageName)
                hotelImageView.image = image
                
                // Apply random color
                hotelImageView.tintColor = colorFromName(review.reviewerName)
                
            } else {
                hotelImageView.image = UIImage(systemName: "person.circle.fill")
                hotelImageView.tintColor = .systemGray
            }
        }

        reviewedDateLabel.text = formattedDate(from: review.createdOn)
        ratingsView.rating = Double(review.rating)
        reviewDescriptionLabel.text = review.reviewText
    }
    
    
    
    
    func getHotelImage(for history: Review) -> (String?,String?) {
        let hotelDict = Dictionary(uniqueKeysWithValues: HotelDataMaganer.shared.allHotels.map { ($0.id, $0) })
        return (hotelDict[history.hotelID]?.coverImageURL, hotelDict[history.hotelID]?.name)
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
