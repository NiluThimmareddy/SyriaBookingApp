//
//  HotelThumbnailImagesCVC.swift
//  SyriaBookingApp
//
//  Created by toqsoft on 25/08/25.
//

import UIKit
import SkeletonView

class HotelThumbnailImagesCVC : UICollectionViewCell {
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var thumbnailImgView: UIImageView!
    
    override var isSelected: Bool {
        didSet {
            backView.applyCardStyle()
            backView.layer.borderWidth = isSelected ? 3 : 0
            backView.layer.borderColor = isSelected ? UIColor.label.cgColor : UIColor.clear.cgColor
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.isSkeletonable = true
        self.contentView.isSkeletonable = true
        thumbnailImgView.contentMode = .scaleToFill
        thumbnailImgView.clipsToBounds = true
    }
    
}
