//
//  SliderCollectionViewCell.swift
//  SyriaBookingApp
//
//  Created by ToqSoft on 03/09/25.
//

import UIKit

class SliderCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var greetingMessageLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    var loginClicked : (()-> Void)?
    
    @IBAction func LoginButtonAction(_ sender: UIButton) {
        self.loginClicked?()
    }
}
