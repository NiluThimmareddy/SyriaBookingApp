//
//  PromotionsCollectionViewCell.swift
//  SyriaBookingApp
//
//  Created by toqsoft on 29/07/25.
//

import UIKit

class PromotionsCollectionViewCell : UICollectionViewCell {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var promotionHotelImageView: UIImageView!
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var activityInfoLabel: UILabel!
    @IBOutlet weak var exploreMoreButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backView.applyCardStyle()
    }

    @IBAction func exploreMoreButtonAction(_ sender: Any) {
        
    }
    
    func configuration(with model: Hotel) {
        if let firstImageURL = model.images.first, !firstImageURL.isEmpty {
            promotionHotelImageView.loadImage(from: firstImageURL)
        } else if let coverImageURL = model.coverImageURL, !coverImageURL.isEmpty {
            promotionHotelImageView.loadImage(from: coverImageURL)
        } else {
            promotionHotelImageView.image = UIImage(named: "placeholder")
        }
    }
}
