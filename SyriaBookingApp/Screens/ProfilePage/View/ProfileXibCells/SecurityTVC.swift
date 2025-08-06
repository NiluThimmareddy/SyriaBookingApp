//
//  SecurityTVC.swift
//  HotelBooking
//
//  Created by praveenkumar on 30/06/25.
//

import UIKit

class SecurityTVC: UITableViewCell {

    @IBOutlet weak var deleteAccountButton: UIButton!
    @IBOutlet weak var arrowImage: UIImageView!
    @IBOutlet weak var contentLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        fontStyle()
        deleteAccountButton.backViewBlackShadow()
        deleteAccountButton.layer.cornerRadius = 10
    }
    func fontStyle(){
        titleLbl.font = UIFont.poppinsBold(16)
        contentLbl.font = UIFont.poppinsMedium(12)
        
        let delete = NSAttributedString(
            string: "Delete Account",
            attributes: [.font: UIFont.poppinsBold(12), .foregroundColor: UIColor.red]
        )
        deleteAccountButton.setAttributedTitle(delete, for: .normal)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }
    
    @IBAction func deleteAccountButton(_ sender: Any) {
    }
}
