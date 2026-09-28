//
//  MessagesTVC.swift
//  HotelBooking
//
//  Created by praveenkumar on 10/07/25.
//

import UIKit

class MessagesTVC: UITableViewCell {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var expiresInDays: UILabel!
    @IBOutlet weak var bookedDate: UILabel!
    @IBOutlet weak var hotelName: UILabel!
    @IBOutlet weak var hotelImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        hotelImage.layer.cornerRadius = hotelImage.frame.size.height / 2
        backView.layer.cornerRadius = 10
        backView.layer.borderWidth = 1
        backView.layer.borderColor = UIColor.lightGray.cgColor
    }

    @IBAction func menuButton(_ sender: Any) {
    }
    
}
