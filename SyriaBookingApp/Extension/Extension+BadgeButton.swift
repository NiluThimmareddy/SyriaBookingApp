//
//  Extension+BadgeButton.swift
//  SyriaBookingApp
//
//  Created by ToqSoft on 19/09/25.
//

import UIKit

class BadgeButton: UIButton {
    private let badgeLabel = UILabel()
    
    var badge: Int = 0 {
        didSet {
            DispatchQueue.main.async{
                self.badgeLabel.text = "\(self.badge)"
                self.badgeLabel.isHidden = self.badge == 0
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBadge()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupBadge()
    }
    
    private func setupBadge() {
        badgeLabel.frame = CGRect(x: 20, y: -5, width: 15, height: 15)
        badgeLabel.backgroundColor = .systemRed
        badgeLabel.textColor = .white
        badgeLabel.font = .systemFont(ofSize: 8, weight: .bold)
        badgeLabel.textAlignment = .center
        badgeLabel.layer.cornerRadius = 7.5
        badgeLabel.clipsToBounds = true
        badgeLabel.isHidden = true
        addSubview(badgeLabel)
    }
}
