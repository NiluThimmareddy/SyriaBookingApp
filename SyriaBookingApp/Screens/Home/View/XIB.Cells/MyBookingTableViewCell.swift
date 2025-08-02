//
//  MyBookingTableViewCell.swift
//  SyriaBookingApp
//
//  Created by ToqSoft on 02/08/25.
//

import UIKit

class MyBookingTableViewCell: UITableViewCell {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var checkinLabel: UILabel!
    @IBOutlet weak var checkoutLabel: UILabel!
    @IBOutlet weak var hotelImageView: UIImageView!
    @IBOutlet weak var statusButton: UIButton!
    @IBOutlet weak var hotelAddressLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var orderIdLabel: UILabel!
    @IBOutlet weak var hotelNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backView.applyCardStyle()
        setupUI()
    }

    func setupUI(){
        DispatchQueue.main.async {
            self.checkinLabel.addBorder(edge: .right, color: .systemGray4, thickness: 0.8)
            self.checkoutLabel.addBorder(edge: .left, color: .systemGray4, thickness: 0.8)
            
        }
    }
    
    func configure(with hotel : Hotel) {
//        let Intrating = Int(hotel.StarRating ?? 0.0)
//        
//        let hotelNameAttribute = NSMutableAttributedString(
//            string: "\(hotel.HotelName + " ")",
//            attributes: [.foregroundColor: UIColor.label]
//        )
//        
//        if Intrating > 0 && Intrating <= 5{
//            let stars = String(repeating: "★", count: Intrating)
//            let starAttributedString = NSAttributedString(
//                string : stars,
//                attributes: [.foregroundColor: UIColor.systemYellow]
//            )
//            
//            hotelNameAttribute.append(starAttributedString)
//        }
//        hotelNameLabel.attributedText = hotelNameAttribute
//        
//        if let room = room {
//            priceLabel.text = "$\(room.basePrice)"
//        } else {
//            priceLabel.text = "N/A"
//        }
    }
//    
    @IBAction func statusButtonAction(_ sender: Any) {
    }
}
