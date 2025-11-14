//
//  SliderCollectionViewCell.swift
//  SyriaBookingApp
//
//  Created by ToqSoft on 03/09/25.
//

import UIKit
import SkeletonView

class SliderCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var greetingMessageLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    
    var loginClicked : (()-> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.isSkeletonable = true
        self.contentView.isSkeletonable = true
        if AppSettings.shared.selectedLanguage == .arabic {
            loginButton.setTitle("تسجيل الدخول", for: .normal)
            loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .heavy)
            loginButton.semanticContentAttribute = .forceLeftToRight
        } else {
            loginButton.setTitle("Login", for: .normal)
            loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .heavy)
            loginButton.semanticContentAttribute = .forceLeftToRight
        }
    }
    
    @IBAction func LoginButtonAction(_ sender: UIButton) {
        self.loginClicked?()
    }
}
