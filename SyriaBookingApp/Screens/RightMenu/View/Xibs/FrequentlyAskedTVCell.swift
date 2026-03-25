//
//  FrequentlyAskedTVCell.swift
//  SyriaBookingApp
//
//  Created by Toqsoft on 25/03/26.
//

import UIKit

class FrequentlyAskedTVCell: UITableViewCell {
    
    @IBOutlet weak var designView: UIView!
    @IBOutlet weak var serialNumLabel: UILabel!
    @IBOutlet weak var imageLabel: UIImageView!
    @IBOutlet weak var headLineLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.semanticContentAttribute = .forceLeftToRight
        headLineLabel.semanticContentAttribute = .forceLeftToRight
        headLineLabel.textAlignment = .left
        
        descriptionLabel.semanticContentAttribute = .forceLeftToRight
        descriptionLabel.textAlignment = .left
        
        serialNumLabel.semanticContentAttribute = .forceLeftToRight
        serialNumLabel.textAlignment = .center
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
