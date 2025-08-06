//
//  ManageAccountsCVC.swift
//  HotelBooking
//
//  Created by praveenkumar on 30/06/25.
//

import UIKit

class ManageAccountsCVC: UICollectionViewCell {

    @IBOutlet weak var titleImage: UIImageView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        backView.BackViewShadow()
        titleLbl.font = .poppinsMedium(12)
    }

}
