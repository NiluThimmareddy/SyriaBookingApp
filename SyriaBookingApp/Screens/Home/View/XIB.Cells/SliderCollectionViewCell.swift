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
        configureButtonTitle()
    }
    
    @IBAction func LoginButtonAction(_ sender: UIButton) {
        self.loginClicked?()
    }
    
    
    func configureButtonTitle() {
        
//        let hasSignedUp = UserSessionManager.hasEverSignedUp()
        let isArabic = AppSettings.shared.selectedLanguage == .arabic
        
        let title = isArabic
               ? "تسجيل الدخول | إنشاء حساب"
               : "Login | Sign Up"
        
        loginButton.setTitle(title, for: .normal)
        
        loginButton.titleLabel?.font = UIFont.systemFont(
            ofSize: isArabic ? 13 : 14,
            weight: .heavy
        )
        loginButton.semanticContentAttribute = isArabic ? .forceRightToLeft : .forceLeftToRight
    }

}
