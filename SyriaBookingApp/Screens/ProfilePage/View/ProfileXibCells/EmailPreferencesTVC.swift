//
//  EmailPreferencesTVC.swift
//  HotelBooking
//
//  Created by praveenkumar on 03/07/25.
//

import UIKit

class EmailPreferencesTVC: UITableViewCell {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var swictchButton: UISwitch!
    @IBOutlet weak var contentLbl: UILabel!
    @IBOutlet weak var title: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        fontText()
        swictchButton.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        roundRightSideCornersOnly()
    }

    private func roundRightSideCornersOnly() {
        backView.layer.cornerRadius = 10
        backView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        backView.clipsToBounds = true
    }


    
    func fontText(){
        title.font = UIFont.poppinsBold(14)
        contentLbl.font = UIFont.poppinsMedium(14)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }
    
    @IBAction func swictchButton(_ sender: Any) {
    }
}
