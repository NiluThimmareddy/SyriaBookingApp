//
//  RoomNextListTVC.swift
//  HotelBooking
//
//  Created by praveenkumar on 08/07/25.
//

import UIKit

class RoomNextListTVC: UITableViewCell {

    @IBOutlet weak var reasonLbl: UILabel!
    @IBOutlet weak var roomPrice: UILabel!
    @IBOutlet weak var roomCount: UILabel!
    @IBOutlet weak var roomType: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        fontText()
    }
    
    func fontText(){
        reasonLbl.font = UIFont.poppinsMedium(14)
        roomType.font = UIFont.poppinsMedium(14)
        roomCount.font = UIFont.poppinsMedium(14)
        roomPrice.font = UIFont.poppinsMedium(14)
    }
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
}
