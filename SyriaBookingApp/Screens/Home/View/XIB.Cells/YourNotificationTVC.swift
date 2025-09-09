//
//  YourNotificationTVC.swift
//  HotelBooking
//
//  Created by praveenkumar on 09/07/25.
//

import UIKit

class YourNotificationTVC: UITableViewCell {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var hotelNameLabel: UILabel!
    @IBOutlet weak var datesLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var upComingDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
