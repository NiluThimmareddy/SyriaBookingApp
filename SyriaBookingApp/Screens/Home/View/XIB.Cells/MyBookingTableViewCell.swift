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
    
    func configure(with hotel: Hotel) {
        
        if let firstImageURL = hotel.images.first, !firstImageURL.isEmpty {
            hotelImageView.loadImage(from: firstImageURL)
        } else {
            hotelImageView.loadImage(from: hotel.coverImageURL)
        }
        
        if let intrating = Int(hotel.averageRating), intrating > 0, intrating <= 5 {
            let hotelNameAttribute = NSMutableAttributedString(
                string: "\(hotel.name) ",
                attributes: [.foregroundColor: UIColor.label]
            )
            
            let stars = String(repeating: "★", count: intrating)
            let starAttributedString = NSAttributedString(
                string: stars,
                attributes: [.foregroundColor: UIColor.systemYellow]
            )
            
            hotelNameAttribute.append(starAttributedString)
            hotelNameLabel.attributedText = hotelNameAttribute
        } else {
            hotelNameLabel.text = hotel.name
        }
        priceLabel.text = "$\(hotel.minRoomPrice)"
        orderIdLabel.text = hotel.id
        hotelAddressLabel.text = hotel.city
    }

 
    @IBAction func statusButtonAction(_ sender: Any) {
    }
}
