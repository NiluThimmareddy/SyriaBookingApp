//
//  ExpectationMeetsTVC.swift
//  HotelBooking
//
//  Created by praveenkumar on 16/06/25.
//

import UIKit

class ExpectationMeetsTVC: UITableViewCell {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var tickImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLbl.font = .poppinsMedium(12)
    }
    
}
