//
//  RecentlyViewedCVC.swift
//  HotelBooking
//
//  Created by toqsoft on 24/06/25.
//

import UIKit

class RecentlyViewedCVC: UICollectionViewCell {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var hotelImgView: UIImageView!
    @IBOutlet weak var hotelNameLabel: UILabel!
        
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(with hotel: Hotel) {
        hotelNameLabel.text = "\(hotel.name),\n \(hotel.city)"
        if let firstImageURL = hotel.images.first, !firstImageURL.isEmpty {
            hotelImgView.loadImage(from: firstImageURL)
        } else {
            hotelImgView.loadImage(from: hotel.coverImageURL)
        }
    }
}
