//
//  ArchiveTableViewCell.swift
//  SyriaBookingApp
//
//  Created by toqsoft on 11/09/25.
//

import UIKit

class ArchiveTableViewCell : UITableViewCell {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var hotelIdLabel: UILabel!
    @IBOutlet weak var datesLabel: UILabel!
    @IBOutlet weak var pendingLabel: UILabel!
    @IBOutlet weak var featureDateLabel: UILabel!
    @IBOutlet weak var totalAmountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backView.applyCardStyle()
        pendingLabel.layer.cornerRadius = 6
        pendingLabel.clipsToBounds = true
    }
    
}
