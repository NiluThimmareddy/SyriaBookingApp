//
//  WhyWorkWithUsCVC.swift
//  SyriaBookingApp
//
//  Created by Toqsoft on 23/03/26.
//

import UIKit

class WhyWorkWithUsCVC: UICollectionViewCell {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var iconImgView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backView.applyCardStyle()
        imgView.layer.cornerRadius = 12
        imgView.clipsToBounds = true
        imgView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
    }

}
