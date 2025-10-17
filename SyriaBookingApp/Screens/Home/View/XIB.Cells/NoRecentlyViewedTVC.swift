//
//  NoRecentlyViewedTVC.swift
//  SyriaBookingApp
//
//  Created by toqsoft on 17/10/25.
//

import UIKit

class NoRecentlyViewedTVC: UITableViewCell {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var clockImgView: UIImageView!
    @IBOutlet weak var noRecentlyViewTitleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        let lang = AppSettings.shared.selectedLanguage
        
        if lang == .english {
            noRecentlyViewTitleLabel.text = "No Recently Viewed Hotels"
            descriptionLabel.text = "Hotels you view will appear here for easy access later."
        } else {
            noRecentlyViewTitleLabel.text = "لا توجد فنادق شوهدت مؤخرًا"
            descriptionLabel.text = "ستظهر الفنادق التي تشاهدها هنا للوصول السهل لاحقًا."
        }
        
        clockImgView.image = UIImage(systemName: "clock")
        clockImgView.tintColor = .lightGray
    }
}
