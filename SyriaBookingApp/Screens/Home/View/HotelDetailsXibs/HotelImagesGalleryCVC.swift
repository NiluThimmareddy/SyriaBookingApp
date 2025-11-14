//
//  HotelImagesGalleryCVC.swift
//  SyriaBookingApp
//
//  Created by toqsoft on 25/08/25.
//

import UIKit
import SkeletonView

protocol HotelImagesGalleryCVCDelegate: AnyObject {
    func didTap360ViewButton(in cell: HotelImagesGalleryCVC)
}

class HotelImagesGalleryCVC : UICollectionViewCell {
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var hotelImageView: UIImageView!
    
    weak var delegate: HotelImagesGalleryCVCDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.isSkeletonable = true
        self.contentView.isSkeletonable = true
        backView.applyCardStyle()
        hotelImageView.contentMode = .scaleToFill
        hotelImageView.clipsToBounds = true
    }
    
    @IBAction func threeSixtyDegreesViewButtonAction(_ sender: Any) {
        delegate?.didTap360ViewButton(in: self)
    }
    
}
