//
//  FlagNameWithImageTVC.swift
//  HotelBooking
//
//  Created by praveenkumar on 14/07/25.
//

import UIKit

class FlagNameWithImageTVC: UITableViewCell {

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var flagImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        nameLbl.font = UIFont.poppinsMedium(14)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }
    
}
