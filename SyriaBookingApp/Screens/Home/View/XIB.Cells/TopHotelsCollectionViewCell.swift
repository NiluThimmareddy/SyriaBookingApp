//
//  TopHotelsCollectionViewCell.swift
//  SyriaBookingApp
//
//  Created by toqsoft on 28/07/25.
//

import UIKit

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
    }
    
    func configuration(with model: Hotel) {
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
        hotelNameLabel.text = model.name
        cityNameLabel.text = model.city.rawValue
        distanceLabel.text = model.landmarkDescription
        starRatingView.rating = Double(model.averageRating) ?? 0.0
        priceLabel.text = "\(model.minRoomPrice.rawValue) / night"
        reviewsLabel.text = "\(model.averageRating) (\(model.reviewCount) reviews)"
    }
}
