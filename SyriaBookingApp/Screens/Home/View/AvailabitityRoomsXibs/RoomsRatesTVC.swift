//
//  RoomsRatesTVC.swift
//  SyriaBookingApp
//
//  Created by toqsoft on 06/08/25.
//

import UIKit

class RoomsRatesTVC : UITableViewCell {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var checkMarkButton: UIButton!
    @IBOutlet weak var roomPriceLabel: UILabel!
    @IBOutlet weak var selectRoomsButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    @IBAction func checkMarkButtonAction(_ sender: Any) {
    }
    
    func configure(with rooms: Rate) {
        let notes = rooms.notes ?? "No notes"
        roomPriceLabel.text = "\(rooms.price): \(notes)"
    }

}
