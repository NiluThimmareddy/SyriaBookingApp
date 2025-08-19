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
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
