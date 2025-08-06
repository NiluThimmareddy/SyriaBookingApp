//
//  UserFeedBackAfterCheckOutTVC.swift
//  HotelBooking
//
//  Created by praveenkumar on 13/06/25.
//

import UIKit

class UserFeedBackAfterCheckOutTVC: UITableViewCell {
    
   
    @IBOutlet weak var backViewTrailingCons: NSLayoutConstraint!
    @IBOutlet weak var backViewLeadingCons: NSLayoutConstraint!
    @IBOutlet weak var backViewBottomCons: NSLayoutConstraint!
    @IBOutlet weak var backViewTopCons: NSLayoutConstraint!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var titleData: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleData.font = .poppinsMedium(14)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
