//
//  PopularFAQTVC.swift
//  HotelBooking
//
//  Created by praveenkumar on 30/06/25.
//

import UIKit

class PopularFAQTVC: UITableViewCell {
    @IBOutlet weak var bottomViewHeightCons: NSLayoutConstraint!
    @IBOutlet weak var bottomTopView: UIView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var answerLbl: UILabel!
    @IBOutlet weak var questionLbl: UILabel!
    @IBOutlet weak var arrowImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        arrowImage.image = UIImage(systemName: "chevron.down.square")
        questionLbl.font = UIFont.poppinsMedium(14)
        answerLbl.font = UIFont.poppinsMedium(14)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
}
