//
//  ProfileTVC.swift
//  HotelBooking
//
//  Created by praveenkumar on 26/06/25.
//

import UIKit

class ProfileTVC: UITableViewCell {

    @IBOutlet weak var imageLeading: NSLayoutConstraint!
    @IBOutlet weak var viewTrailing: NSLayoutConstraint!
    @IBOutlet weak var viewLeading: NSLayoutConstraint!
    @IBOutlet weak var profileListArrowButton: UIButton!
    @IBOutlet weak var profileListLbl: UILabel!
    @IBOutlet weak var profileListImages: UIImageView!
    @IBOutlet weak var profileListBackView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }
    
    @IBAction func profileListArrowButton(_ sender: Any) {
    }
   
}
