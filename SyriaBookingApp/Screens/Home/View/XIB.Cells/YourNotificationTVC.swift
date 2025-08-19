//
//  YourNotificationTVC.swift
//  HotelBooking
//
//  Created by praveenkumar on 09/07/25.
//

import UIKit

class YourNotificationTVC: UITableViewCell {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var viewYourBookingLbl: UILabel!
    @IBOutlet weak var bookingConfirmationLbl: UILabel!
    @IBOutlet weak var hotelImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        hotelImage.layer.cornerRadius = hotelImage.frame.size.height / 2
        dateLbl.font = UIFont.poppinsMedium(14)
        viewYourBookingLbl.font = UIFont.poppinsMedium(14)
        bookingConfirmationLbl.font = UIFont.poppinsMedium(16)
        backView.BackViewShadow()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
