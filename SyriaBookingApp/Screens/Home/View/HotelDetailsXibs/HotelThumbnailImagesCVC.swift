//
//  HotelThumbnailImagesCVC.swift
//  SyriaBookingApp
//
//  Created by toqsoft on 25/08/25.
//

import UIKit

class HotelThumbnailImagesCVC : UICollectionViewCell {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var thumbnailImgView: UIImageView!
    
    override var isSelected: Bool {
        didSet {
            backView.applyCardStyle()
            thumbnailImgView.layer.borderWidth = isSelected ? 3 : 0
            thumbnailImgView.layer.borderColor = isSelected ? UIColor.label.cgColor : UIColor.clear.cgColor
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        thumbnailImgView.contentMode = .scaleToFill
        thumbnailImgView.clipsToBounds = true
    }
    
}
