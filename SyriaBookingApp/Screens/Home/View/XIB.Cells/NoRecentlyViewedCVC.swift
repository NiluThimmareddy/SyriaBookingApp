//
//  NoRecentlyViewedCVC.swift
//  SyriaBookingApp
//
//  Created by toqsoft on 29/08/25.
//

import UIKit

class NoRecentlyViewedCVC : UICollectionViewCell {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var noRecentlyLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backView.applyCardStyle()
    }

}
