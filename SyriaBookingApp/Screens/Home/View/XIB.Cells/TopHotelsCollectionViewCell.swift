//
//  TopHotelsCollectionViewCell.swift
//  SyriaBookingApp
//
//  Created by toqsoft on 28/07/25.
//

import UIKit

protocol TopHotelsCollectionViewCellDelegate: AnyObject {
    func didTapBookNow(for hotel: Hotel)
}

class TopHotelsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var hotelImgView: UIImageView!
    @IBOutlet weak var offerLabel: UILabel!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var reviewsView: UIView!
    @IBOutlet weak var reviewsLabel: UILabel!
    @IBOutlet weak var hotelNameLabel: UILabel!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var starRatingView: CosmosView!
    @IBOutlet weak var bookNowButton: UIButton!
    @IBOutlet weak var offerView: UIView!
    
    weak var delegate: TopHotelsCollectionViewCellDelegate?
    var hotel: Hotel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backView.applyCardStyle()
        reviewsView.applyCardStyle()
        reviewsView.layer.cornerRadius = UIDevice.current.userInterfaceIdiom == .pad ? 20 : 15
        hotelImgView.clipsToBounds = true
        hotelImgView.layer.cornerRadius = 20
        hotelImgView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }

    @IBAction func bookNowButtonAction(_ sender: Any) {
        if let hotel = hotel {
            delegate?.didTapBookNow(for: hotel)
        }
    }
    
    func configuration(with model: Hotel) {
        self.hotel = model
        if let firstImageURL = model.images.first, !firstImageURL.isEmpty {
            hotelImgView.loadImage(from: firstImageURL)
        } else {
            hotelImgView.loadImage(from: model.coverImageURL)
        }

        if let discount = model.discountText, !discount.isEmpty {
            offerLabel.text = "\(discount) Off"
            offerView.isHidden = false
        } else {
            offerLabel.text = ""
            offerView.isHidden = true
        }

        let ratingValue = model.starRating
        let intRating = Int(ratingValue)

        let hotelNameAttributed = NSMutableAttributedString(
            string: "\(model.localizedName()) ",
            attributes: [.foregroundColor: UIColor.label]
        )

        if intRating > 0 && intRating <= 5 {
            let stars = String(repeating: "★", count: intRating)
            let starAttributed = NSAttributedString(
                string: stars,
                attributes: [.foregroundColor: UIColor.black]
            )
            hotelNameAttributed.append(starAttributed)
        }

        hotelNameLabel.attributedText = hotelNameAttributed

        cityNameLabel.text = model.localizedCity()
        distanceLabel.text = model.landmarkDescription
        starRatingView.rating = Double(ratingValue)
     //   priceLabel.text = "\(model.minRoomPrice) / night"
        //reviewsLabel.text = "\(model.averageRating) (\(model.reviewCount) reviews)"
        
        if AppSettings.shared.selectedLanguage == .english {
            priceLabel.text = "\(model.minRoomPrice) / \n night"
            
        }else{
            priceLabel.text = "\(model.minRoomPrice) / \n نان"
        }
        
      
        if AppSettings.shared.selectedLanguage == .english {
            reviewsLabel.text = "\(model.averageRating) (\(model.reviewCount) reviews)"
        } else {
            reviewsLabel.text = "\(model.averageRating) (\(model.reviewCount) مراجعات)"
        }

        if AppSettings.shared.selectedLanguage == .arabic {
            bookNowButton.setTitle("احجز الآن", for: .normal)
        } else {
            bookNowButton.setTitle("Book Now", for: .normal)
        }
    }
}
