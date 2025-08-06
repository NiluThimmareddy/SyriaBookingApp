//
//  InfoAndContactTVC.swift
//  HotelBooking
//
//  Created by praveenkumar on 10/07/25.
//

import UIKit

class InfoAndContactTVC: UITableViewCell {

    @IBOutlet weak var contentLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var backView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        fontText()
    }
    func fontText(){
        contentLbl.font = UIFont.poppinsMedium(14)
        titleLbl.font = UIFont.poppinsBold(14)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        roundTopRightCornerOnly()
    }
    
    private func roundTopRightCornerOnly() {
        backView.layer.cornerRadius = backView.frame.size.height / 2
        backView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        backView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
