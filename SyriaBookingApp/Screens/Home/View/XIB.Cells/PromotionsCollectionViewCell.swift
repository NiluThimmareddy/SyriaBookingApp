//
//  PromotionsCollectionViewCell.swift
//  SyriaBookingApp
//
//  Created by toqsoft on 29/07/25.
//

import UIKit
import SkeletonView

protocol PromotionsCollectionViewCellDelegate: AnyObject {
    func didTapExploreMore(in cell: PromotionsCollectionViewCell)
}

class PromotionsCollectionViewCell : UICollectionViewCell {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var promotionHotelImageView: UIImageView!
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var activityInfoLabel: UILabel!
    @IBOutlet weak var exploreMoreButton: UIButton!
    @IBOutlet weak var promotionsLabel: UILabel!
    
    
    weak var delegate: PromotionsCollectionViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.isSkeletonable = true
        self.contentView.isSkeletonable = true
        backView.applyCardStyle()
        activityInfoLabel.font = .captionFont
    }

    @IBAction func exploreMoreButtonAction(_ sender: Any) {
        delegate?.didTapExploreMore(in: self)
    }
    
    func configuration(with model: Hotel) {
        destinationLabel.text = "\(model.localizedName()), \(model.localizedCity())"
        if AppSettings.shared.selectedLanguage == .english {
            activityInfoLabel.text = "\(model.reviewCount) Reviews ⎸ \(model.averageRating) Rating"
            promotionsLabel.text = "Promotions"
        } else {
            activityInfoLabel.text = "\(model.reviewCount) مراجعات، \(model.averageRating) تقييم"
            promotionsLabel.text = "عروض"
        }
       
        if let firstImageURL = model.images.first, !firstImageURL.isEmpty {
            promotionHotelImageView.loadImage(from: firstImageURL)
        } else {
            promotionHotelImageView.loadImage(from: model.coverImageURL)
        }
    }
}
