//
//  SuggestionCVC.swift
//  HotelBooking
//
//  Created by praveenkumar on 14/07/25.
//

import UIKit

class SuggestionCVC: UICollectionViewCell {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        backView.layer.cornerRadius = 5
    }

}
