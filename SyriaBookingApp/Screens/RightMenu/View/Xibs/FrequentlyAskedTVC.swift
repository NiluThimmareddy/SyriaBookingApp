//
//  FrequentlyAskedTVC.swift
//  NewProject
//
//  Created by Yarramsetti Yedukondalu on 06/08/25.
//

import UIKit

class FrequentlyAskedTVC: UITableViewCell {

    @IBOutlet weak var designView: UIView!
    @IBOutlet weak var serialNumLabel: UILabel!
    @IBOutlet weak var imageLabel: UIImageView!
    @IBOutlet weak var headLineLabel: UILabel!
    @IBOutlet weak var imageUIView: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var lineView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.semanticContentAttribute = .forceLeftToRight
        headLineLabel.semanticContentAttribute = .forceLeftToRight
        headLineLabel.textAlignment = .left
        
        descriptionLabel.semanticContentAttribute = .forceLeftToRight
        descriptionLabel.textAlignment = .left
        
        serialNumLabel.semanticContentAttribute = .forceLeftToRight
        serialNumLabel.textAlignment = .left
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
