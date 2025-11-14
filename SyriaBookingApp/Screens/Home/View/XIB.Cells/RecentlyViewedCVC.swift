//
//  RecentlyViewedCVC.swift
//  HotelBooking
//
//  Created by toqsoft on 24/06/25.
//

import UIKit
import SkeletonView

class RecentlyViewedCVC: UICollectionViewCell {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var hotelImgView: UIImageView!
    @IBOutlet weak var hotelNameLabel: UILabel!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        hotelNameLabel.font = .captionFont
        self.isSkeletonable = true
        self.contentView.isSkeletonable = true
    }
    
    func configure(with hotel: Hotel) {
        hotelNameLabel.text = "\(hotel.localizedName())\n\(hotel.localizedCity())"
        if let firstImageURL = hotel.images.first, !firstImageURL.isEmpty {
            hotelImgView.loadImage(from: firstImageURL)
        } else {
            hotelImgView.loadImage(from: hotel.coverImageURL)
        }
    }
}
