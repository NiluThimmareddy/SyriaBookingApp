//
//  PromotionsCollectionViewCell.swift
//  SyriaBookingApp
//
//  Created by toqsoft on 29/07/25.
//

import UIKit

protocol PromotionsCollectionViewCellDelegate: AnyObject {
    func didTapExploreMore(in cell: PromotionsCollectionViewCell)
}

class PromotionsCollectionViewCell : UICollectionViewCell {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var promotionHotelImageView: UIImageView!
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var activityInfoLabel: UILabel!
    @IBOutlet weak var exploreMoreButton: UIButton!
    
    weak var delegate: PromotionsCollectionViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backView.applyCardStyle()
    }

    @IBAction func exploreMoreButtonAction(_ sender: Any) {
        delegate?.didTapExploreMore(in: self)
    }
    
    func configuration(with model: Hotel) {
        destinationLabel.text = "\(model.localizedName()), \(model.localizedCity())"
        activityInfoLabel.text = "\(model.reviewCount) Reviews, \(model.averageRating) Rating"
        if let firstImageURL = model.images.first, !firstImageURL.isEmpty {
            promotionHotelImageView.loadImage(from: firstImageURL)
        } else {
            promotionHotelImageView.loadImage(from: model.coverImageURL)
        }
    }
}
