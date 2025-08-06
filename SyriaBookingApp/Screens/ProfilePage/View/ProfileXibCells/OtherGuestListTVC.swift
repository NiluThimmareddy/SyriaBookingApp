//
//  OtherGuestListTVC.swift
//  HotelBooking
//
//  Created by praveenkumar on 08/07/25.
//

import UIKit

protocol OtherGuestListTVCDelegate: AnyObject {
    func didTapEditButton(in cell: OtherGuestListTVC)
    func didTapDeleteButton(in cell: OtherGuestListTVC)
}

class OtherGuestListTVC: UITableViewCell {

    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var nameLbl: UILabel!
    
    weak var delegate: OtherGuestListTVCDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backView.layer.cornerRadius = 10
        backView.layer.borderWidth = 1
        backView.layer.borderColor = UIColor.lightGray.cgColor
        nameLbl.font = UIFont.poppinsMedium(14)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }
    
    @IBAction func deleteButton(_ sender: Any) {
        delegate?.didTapDeleteButton(in: self)
    }
    
    @IBAction func editButton(_ sender: Any) {
        delegate?.didTapEditButton(in: self)
    }
}
